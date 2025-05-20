/*The TECH=DSC option in the PROC VARREDUCE statement requests a discriminant analysis 
of the Heart data table for feature selection. The ODS OUTPUT statement stores the 
"Selection Summary" table as a local file named Summary. The MATRIX =COV option in the 
PROC VARREDUCE statement requests that selections be done based on the covariance matrix. 
The BIC option specifies the stop criterion, and the MAXITER= option specifies 15 as the 
maximum number of iterations. The selection process terminates when the BIC statistic 
increases in the last three consecutive steps. */

proc varreduce data=sashelp.heart matrix=COV tech=DSC;
   ods output SelectionSummary=Summary;
   class Status Sex Chol_Status BP_Status Weight_Status Smoking_Status;
   reduce supervised Status = Sex AgeAtStart Height Weight Diastolic Systolic MRW
                              Smoking Cholesterol Chol_Status BP_Status Weight_Status
                              Smoking_Status/ maxiter=15 BIC;
   display 'SelectionSummary' 'SelectedEffects';
run;

proc sgplot data=Summary;
   series x=Iteration  y=BIC;
run;