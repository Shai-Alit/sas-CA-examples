*/
	source: https://support.sas.com/kb/24/299.html
	author: Sean T Ford
			sean.ford@sas.com
	date: 5/3/2023

	description:  Fitting separate distributions for each of several variables or BY groups
				  Overlaid Plots using PROC SGPLOT.
*/

*create sample data;
data test;
 drop i;
 do group='A','B';
  do i=1 to 100;
   if group='A' then x=25 + 8*rannor(2345);
   else x=5 + 8*rannor(12345);
   output;
  end;
 end;
run;

*requires separate variabels instead of by groups, so re-arrange the data;
proc transpose data=test out=interim;
 by group;
 var x;
run;
proc transpose data= interim out=test2(drop=_name_);
 id group;
run;

*generate the plot;
proc sgplot data=test2;
*note - inputs after the / are plotting options associated with each type of plotting object;
 density A / type=normal lineattrs=(color=red) legendlabel='A'; *create density plot of A variable from data set "test2";
 density B / type=normal lineattrs=(color=blue) legendlabel='B';
 histogram A / transparency=0.75 fillattrs=(color=red);
 histogram B / transparency=0.75 fillattrs=(color=blue);
  keylegend / location=outside position=bottom; * set legend position;
  xaxis label="Normal Curves"; *label the x axis;
run;
