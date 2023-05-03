*/
	source: https://support.sas.com/kb/24/299.html
	author: Sean T Ford
			sean.ford@sas.com
	date: 5/3/2023

	description:  Fitting separate distributions for each of several variables or BY groups
				  Comparitve plots using PROC UNIVARIATE.
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

title 'Comparative plots'; *give the plots a title;
proc univariate data=test noprint;
 class group; *split plots based on group variable;
  var x; *use the variable x to plot;
 histogram x / vscale=count normal(noprint); *build a histogram of x;
 inset normal(mu sigma); *place the legend with mu and sigma shown;
run;
title;
