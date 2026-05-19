/*
proc python example

Author: Sean T Ford
sean.ford@sas.com

*/

*use automatic variable SYSUSERID to get user currently logged in;
%put SAS code running for &SYSUSERID;

*get the user's home directory;
%let user_home = %SYSGET(HOME);
%put &user_home;

*attempt to use snowflake library;
%let lib = snowlib;

*check if snowflake library exists. if not, use sashelp;
%if %sysfunc(libref(&lib)) = 0 %then %do;
    %put NOTE: Library &lib is assigned.;
%end;
%else %do;
    %let lib=sashelp;
%end;

/*user proc python to do some processing
note that using terminate ensures that a clean python session is started
to use any previously initialized python session, ommit the "terminate" statement
*/
proc python terminate;
submit;

#import the pandas package
import pandas as pd

print(f"Running python code inside SAS Code for user {SAS.symget('SYSUSERID')}")
print(f"The user's home directory is: {SAS.symget('user_home')}")

#get the sas variable containing the library that contains the cars data
saslib = SAS.symget('lib')

#use SAS to get connected library data
df = SAS.sd2df(f'{saslib}.cars')

# Get the row with highest MSRP
max_msrp_row = df.loc[df['MSRP'].idxmax()]

print("\n=== Vehicle with the highest MSRP ===")
print(max_msrp_row)

# Safely get the Model
highest_model = max_msrp_row['Model']      # or .get('Model')

print(f"\nHighest MSRP Model: {highest_model}")

#save the model to a variable that SAS can access
SAS.symput('vehicle_model',highest_model)

#get the 'expensive' cars
expensive_cars = df[df['MSRP'] > 100000].sort_values(by='MSRP', ascending=False)

#save the row to a SAS table
SAS.df2sd(expensive_cars,'work.expensive_cars')

endsubmit;
quit;

%put From python, the most expensive vehicle model is a &vehicle_model;

/* Create a nice label with Make + Model */
data plotdata;
    set work.expensive_cars;
    ModelLabel = catx(" - ", Make, Model);
run;

title "Most Expensive Cars (MSRP > $150,000)";
title2 "Sorted by Price Descending";

proc sgplot data=plotdata;
    hbar ModelLabel / 
         response=MSRP 
         categoryorder=respdesc          /* highest to lowest */
         datalabel 
         datalabelattrs=(size=11 weight=bold)
         fillattrs=graphdata1
         barwidth=0.7;

    xaxis label="MSRP (USD)" 
          grid
          valuesformat=dollar12.; 

    yaxis label="Vehicle Model" 
          display=(nolabel);

run;