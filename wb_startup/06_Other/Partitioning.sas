/*This example demonstrates how to use PROC PARTITION to perform simple random sampling 
on the mycas.hmeq data table.*/

proc partition data=sashelp.homeequity samppct=10 seed=10 nthreads=1;
   output out=work.out2 copyvars=(job reason loan value delinq derog);
   display 'SRSFreq';
run;

proc print data=work.out2(obs=20);
run;

/*The SAMPPCT=10 option requests that 10% of the input data be sampled. The OUTPUT 
statement requests that the sampled data be stored in a table named mycas.out2, and 
the COPYVARS= option lists the variables to be copied from mycas.hmeq to mycas.out2. 
The DISPLAY statement requests that the SRSFreq ODS table be displayed.*/

/*This example demonstrates how to use PROC PARTITION to perform stratified sampling 
to partition the data; it uses the same data table as is used in Example 15.1.*/

proc partition data=sashelp.homeequity samppct=10 samppct2=20 seed=10 partind nthreads=3;
   by bad;
   output out=work.out3 copyvars=(job reason loan value delinq derog);
run;

proc print data=work.out3(obs=20);
run;

/*The SAMPPCT=10 option requests that 10% of the input data be included in the training 
partition, and the SAMPPCT2=20 option requests that 20% of the input data be included 
in the testing partition. The SEED= option specifies 10 as the random seed to be used 
in the partitioning process. The PARTIND option requests that the output data table, 
mycas.out3, include an indicator that shows whether each observation is selected to a 
partition (1 for training or 2 for testing) or not (0). The OUTPUT statement requests 
that the sampled data be stored in a table named mycas.out3, and the COPYVARS= option 
lists the variables to be copied from mycas.hmeq to mycas.out3.*/


/*This example demonstrates how to use PROC PARTITION to perform oversampling; it uses 
the same data table as in Example 15.1.*/

proc partition data=sashelp.homeequity samppctevt=90 eventprop=0.5
               event="1" seed=10 nthreads=1;
   by bad;
   ods output OVERFREQ=outFreq;
   output out=work.out4 copyvars=(job loan value delinq derog)
          freqname=_Freq2_;
run;

proc print data=work.out4(obs=20);
run;

/*The EVENTPROP=0.5 option specifies that 50% of the sample are rare events. The 
SAMPPCTEVT=90 option requests that 90% of the rare events be sampled. The EVENT="1" 
option specifies that the second level of the variable BAD corresponds to a rare event. 
The OUTPUT statement requests that the sampled data be stored in a table named mycas.out4,
specifies the variables to be transferred from the input data table, requests that the 
_Freq_ column be renamed to _Freq2_.*/