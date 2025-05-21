proc import datafile="&WORKSPACE_PATH./github/sas-CA-examples/Data/autoloan.csv"
out=autoloan
dbms=CSV;
run;

data sasfiles.autoloan;
    set work.autoloan;
run;