*/
	source: https://support.sas.com/kb/24/299.html
	author: Sean T Ford
			sean.ford@sas.com
	date: 5/3/2023

	description:  Fitting separate distributions for each of several variables or BY groups
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

*The following statements delete all of the previous graphs that have been written to the WORK.GSEG catalog;

%macro delcat(catname);
 %if %sysfunc(cexist(&catname))
  %then %do;
   proc greplay nofs igout=&catname;
    delete _all_;
   run;
   quit;
  %end;
%mend delcat; 
%delcat(work.gseg) 


title 'Overlay on one set of axes';
goptions nodisplay;
ods graphics off;
axis1 order=(0 to 35 by 5) value=(h=2) label=(h=2);
proc univariate data=test noprint;
 where group='A';
  var x;
 histogram x / normal(noprint color=red)
         nobars
        name='A'
        midpoints=-18 to 48 by 6
         vscale=count
         vaxis=axis1
        height=2;
 inset normal(mu sigma) / pos=nw header='Group A' height=2;
run;
quit;
proc univariate data=test noprint;
 where group='B';
 var x;
 histogram x / normal(noprint color=blue l=20)
        nobars
        name='B'
        midpoints=-18 to 48 by 6
        vscale=count
        vaxis=axis1
        height=2;
 inset normal(mu sigma) / pos=ne header='Group B' height=2;
run;
quit;
goptions display;

/* Replay the graphs into the same template */
proc greplay igout=work.gseg nofs tc=sashelp.templt template=whole;
  treplay 1:A 1:B;
run;
ods graphics on;
