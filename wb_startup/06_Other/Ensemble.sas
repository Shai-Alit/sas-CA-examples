/*Load the data */
data work.autoloan;
    set sasfiles.autoloan;
run;

/*create a partition to separate training and validation data*/
proc partition data=work.autoloan samppct=30 seed=919 partind;
    by BAD;
    output out=work.autoloan;
run;

/*impute missing values, using the training data to calculate median and mode*/
proc varimpute data=work.autoloan(where=(_PartInd_ = 0)) seed=919;
    input JOB REASON / ntech=mode;
    input LOAN LOANDUE VALUE YOJ DEROG DELINQ CLAGE CLNO NINQ DEBTINC / ctech=median;
    code file="/&WORKSPACE_PATH./impute_score_code.sas";
run;

/*apply the imputation to the training and validation data (using median and mode from training data)*/
data work.autoloan_imp;
    set work.autoloan;
    %include "&WORKSPACE_PATH./impute_score_code.sas";
run;

/*select useful input variables*/
proc varreduce data=work.autoloan_imp;
    ods output SelectedEffects=VarSelected;
    class IM_JOB IM_REASON;
    reduce supervised BAD = IM_JOB IM_REASON IM_LOAN IM_LOANDUE IM_VALUE IM_YOJ IM_DEROG IM_DELINQ IM_CLAGE IM_CLNO IM_NINQ IM_DEBTINC / maxeffects=10;
    display 'SelectionSummary' 'SelectedEffects';
run;

/*grab selected effects and store variable names in a macro for use in future procedures*/
proc sql noprint;
    select Variable into :inputs separated by ' '
    from work.varselected;
quit;

%put &inputs;

/*also grab nominal inputs in a separate list, we will need to specify which inputs are nominal for our machine learning models*/
proc sql noprint;
    select Variable into :nominals separated by ' '
    from work.varselected
    where Type="CLASS";
quit;

%put &nominals;

proc sql noprint;
    select Variable into :intervals separated by ' '
    from work.varselected
    where Type="INTERVAL";
quit;

%put &intervals;


/* Train individual models */
proc logistic data=work.autoloan_imp(where=(_PartInd_ = 0));
    class &nominals;
    model BAD = &inputs;
    code file="&WORKSPACE_PATH./logistic_score_code.sas";
run;

proc treesplit data=work.autoloan_imp(where=(_PartInd_ = 0));
    class BAD &nominals;
    model BAD = &inputs;
    prune costcomplexity;
    code file="&WORKSPACE_PATH./treesplit_score_code.sas";
run;


/*score training and validation data using the fitted models*/
data work.logistic_scored;
    set work.autoloan_imp;
    %include "&WORKSPACE_PATH./logistic_score_code.sas";
run;

data work.treesplit_scored;
    set work.autoloan_imp;
    %include "&WORKSPACE_PATH./treesplit_score_code.sas";
run;

proc sort data=logistic_scored;
    by _PartInd_;
run;

proc sort data=treesplit_scored;
    by _PartInd_;
run;

/* Step 3: Combine predictions manually */
data ensemble_scores;
   merge logistic_scored treesplit_scored;
   by _PartInd_;
   final_score = (logistic_scored + treesplit_scored) / 2; /* Simple averaging */
run;

proc astore;
   download rstore = work.ensemble_scores
            store = "&WORKSPACE_PATH./ensembleAstore.sasast";

run;