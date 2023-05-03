*/
	source: https://support.sas.com/kb/24/299.html
	author: Sean T Ford
			sean.ford@sas.com
	date: 5/3/2023

	description:  Fitting multiple distributions to a single variable
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

*With PROC SGPLOT, you can specify multiple HISTOGRAM and DENSITY statements to create overlay plots.;
proc sgplot data=test;
 histogram x;
 density x /type=normal;
 density x /type=normal(mu=12);
run;
