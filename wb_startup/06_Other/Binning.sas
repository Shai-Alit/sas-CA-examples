
/* The following DATA step generates 1,000,000 observations of an ID variable (id) 
and two continuous variables (x1–x2). The mycas CAS library reference enables your 
client machine to communicate with the CAS session.*/
data work.ex1;
   length id 8;
   do id=1 to 1000000;
      x1 = ranuni(101);
      x2 = 10*ranuni(201);
      x3 = 100*ranuni(301);
      output;
   end;
run;

/*Quantile Binning */
/*The following statements demonstrate how to use 
PROC BINNING to perform the quantile binning:*/

proc binning data=work.ex1 numbin=10 method=quantile;
   input x1-x2;
   output out=work.out1;
run;

/* The "Binning Details" table in Quantile Binning shows the binning variable, bin ID, 
bin lower bound, bin upper bound, bin width, number of observations in that bin, and 
some statistics of that bin (such as mean, standard deviation, minimum, and maximum). 
When the binning method is quantile, PROC BINNING assigns the same number of 
observations to each bin for the input variables if possible.*/

/*The following statements include the WINSOR(RATE=0.05) option and generate tables for 
Winsorized and trimmed statistics:*/

proc binning data=work.ex1 numbin=10 method=winsor(rate=0.05);
   input x1-x3;
   output out=work.out2;
run;

/*The following DATA step generates a data table that contains 10 observations of a target
variable (y), three continuous variables (x0–x2), and some other variables. The mycas CAS 
library reference enables your client machine to communicate with the CAS session.*/

data work.ex3;
   input cl1 $ x0  x1  x2  y $ freq id;
   datalines;
a  2  .  7  n  2  1
a  2  2  6  .  3  2
a  3  0  1  o  0  3
c  2  3  7  y  .  4
c  2  .  4  n  -5 5
a  3  6  7  n  3  6
b  1  4  4  y  4  7
b  2  5  6  y  3  8
b  1  6  4  o  1  9
b  2  3  2  n  3  10
;

/*The following statements show how you can use the BINNING procedure to perform bucket 
binning and compute the WOE and the information value (IV):*/

proc binning data=work.ex3 numbin=5 woe;
   input x1/numbin=4;
   input x2;
   target y/event="y";
   output out=work.out3;
run;

/*The DATA= option specifies the input data table. The WOE option enables computation of 
the weight of evidence and information values with WOEADJUST=0.5 by default. The first 
INPUT statement names one continuous variable (x1) as the first input variable for 
binning with four bins. The second INPUT statement names another continuous variable 
(x2) as the second input variable for binning with five bins, as specified in the 
NUMBIN= global option. The TARGET statement names the variable (y) that PROC BINNING 
uses to calculate the weight of evidence, and the EVENT= option specifies the target 
event category in a quoted string. The OUTPUT statement creates an OUTPUT data table 
to contain the results of PROC BINNING.*/


/*The following DATA step generates a data table that contains 10 observations of a 
target variable (y), two continuous variables (x1, x2), and some other variables:*/

data work.ex4;
   input cl1 $ cl2  x1  x2  y  freq id;
   datalines;
a     2    3   7  9   2   1
a     2    2   6  8   3   2
a     3    0   1  5   0   3
c     2    3   7  4   .   4
c     2    .   4  8   -5  5
a     3    6   7  5   3   6
b     1    4   4  8   4   7
b     2    5   6  3   3   8
b     1    6   4  8   1   9
b     2    3   2  6   3   10
;

/*The following statements show how you can use the BINNING procedure to perform 
cutpoint binning:*/

proc binning data=work.ex4 numbin=4 method=cutpts(2, 2.3, 4.5, 3.1, 5);
   input x2;
   input x1/numbin=3;
run;

/*The DATA= option specifies the input data table. The first INPUT statement names one 
continuous variable x2 as the first input variable for binning with 4 bins specified 
by the NUMBIN= global option. The second INPUT statement names another continuous 
variable x1 as the second input variable for binning with 3 bins. The METHOD= option 
specifies that cutpoint binning method will be used. For the first input variable x2, 
2, 2.3, 4.5 (and infinity) will be used as the upper bounds for its 4 bins. For the 
second input variable x1, 3.1, 5 (and infinity) will be used as the upper bounds for 
its 3 bins.*/