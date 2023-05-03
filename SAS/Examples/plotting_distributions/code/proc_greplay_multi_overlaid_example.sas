*/
	source: https://support.sas.com/kb/24/299.html
	author: Sean T Ford
			sean.ford@sas.com
	date: 5/3/2023

	description:  Fitting multiple distributions to a single variable
				  Overlaid Plots using PROC GREPLAY.
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

goptions nodisplay;
ods graphics off;
proc univariate data=test noprint;
  var x;
  histogram x / normal(noprint color=red)
        name='ML'
        vscale=count
        height=2;
 inset normal(mu sigma) / pos=nw header='Max Likelihood Estimates' height=2;
run;
quit;
proc univariate data=test noprint;
  var x;
  histogram x / normal(mu=12 noprint color=blue l=20)
       name='MU'
       nobars
       vscale=count
       height=2;
  inset normal(mu sigma) / pos=ne header=' ' height=2;
run;
quit;

/* Replay the two graphs into the same template */
goptions display;
proc greplay igout=work.gseg nofs tc=sashelp.templt template=whole;
  treplay 1:ML 1:MU;
run;
ods graphics on;
