proc varimpute data=sashelp.homeequity seed=12345;
   input derog clno/ctech=value cvalues=5,20;
   input value /ctech=mean;
   input mortdue /ctech=median;
   input ninq /ctech=random;
   output out=work.out1;
run;

proc print data=work.out1(firstobs=110 obs=124);
run;

/*Fig 1 shows the number of variables for which the missing observations are imputed 
and the random seed value for the random imputation method. 
Fig 2 shows the imputation results.
Fig 3 shows the 15 output observations of the variables that had missing values and 
their new imputed values.*/