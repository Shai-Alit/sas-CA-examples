*/
	source: https://support.sas.com/kb/24/299.html
	author: Sean T Ford
			sean.ford@sas.com
	date: 5/3/2023

	description:  Fitting separate distributions for each of several variables or BY groups
				  Grouped Histograms using PROC GCHART.
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


*note - no distribution options are available with GCHART;
title 'Grouped histograms';
 proc gchart data=test;
 vbar x / group=group;
run;
title;
