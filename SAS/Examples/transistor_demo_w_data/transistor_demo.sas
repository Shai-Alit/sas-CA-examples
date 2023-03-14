cas casauto;
caslib _all_ assign;

*generate example data for portability;
data Trans;
	input Thick @@;
	label Thick='Plating Thickness (mils)';
	datalines;
3.468 3.428 3.509 3.516 3.461 3.492 3.478 3.556 3.482 3.512
3.490 3.467 3.498 3.519 3.504 3.469 3.497 3.495 3.518 3.523
3.458 3.478 3.443 3.500 3.449 3.525 3.461 3.489 3.514 3.470
3.561 3.506 3.444 3.479 3.524 3.531 3.501 3.495 3.443 3.458
3.481 3.497 3.461 3.513 3.528 3.496 3.533 3.450 3.516 3.476
3.512 3.550 3.441 3.541 3.569 3.531 3.468 3.564 3.522 3.520
3.505 3.523 3.475 3.470 3.457 3.536 3.528 3.477 3.536 3.491
3.510 3.461 3.431 3.502 3.491 3.506 3.439 3.513 3.496 3.539
3.469 3.481 3.515 3.535 3.460 3.575 3.488 3.515 3.484 3.482
3.517 3.461 3.431 3.502 3.491 3.506 3.439 3.513 3.496 3.482
;

*0 - 
pull data from:
a) SAS caslib using procsql 
b) SAS caslib using data step
c) csv file;


*a);

/* commented out for portability. Uses data above from data step.
proc sql;
create table trans as select thick from seford_s.transistor;
quit;

*b);
data trans_samples;
set seford_s.transistor_samples;
run;
*/

*change line below to match location of transistor_summary.csv;
*c) same data as above, except loading from csv on server;
proc import datafile="/location/TRANSISTOR_SAMPLES.csv"
        out=trans_samples
        dbms=csv
        replace;
   
     getnames=yes;
run;

*sort the data for proc shewhart;
proc sort data=trans_samples;
by sample;
run;


*randomly select a sample so example has some variability;
proc surveyselect data=trans method=srs n=75 noprint
                  out=trans;
run;

*1 - 
run capability analysis;
proc capability data=Trans outtable=casuser.capout;
	spec lsl=3.45 usl=3.55;
	histogram Thick / normal midpoints=3.4 to 3.6 by 0.025 vscale=count 
		odstitle=title nospeclegend;
	inset lsl usl;
	inset n mean (5.2) cpk (5.2);
run;

*2 - 
run Shewhart to request x-bar chart;
ods graphics on;
title 'Mean Chart for Thicknesses';
proc shewhart data=trans_samples;
xchart Thick*Sample / odstitle = title
markers;
run;
* Note that the control limits vary with the subgroup sample size. 
	The sample size legend in the lower left corner displays the 
	minimum and maximum subgroup sample sizes. By default, the 
	control limits are 3 limits estimated from the data.

*3 - 
run Shewhart to request x-bar and R chart to determine
whether manufactring process is in control;
title 'Mean and Range Charts for Thicknesses';
proc shewhart data=trans_samples;
xrchart Thick*Sample / outtable=casuser.transistor_summary;
run;

*4 - save data to be used in dashboards;
data casuser.capout;
set casuser.capout;
timetag=datetime();
product_id=15781;
run;

*replace "seford_s" with location of capout data;
*concats old data with new data;
data casuser.capout;
merge seford_s.capout casuser.capout;
by timetag;
run;

*replace caslib "seford_s" with desired caslib;
*remove old data if it exists, and update and promote cas tables for use
in VA;
proc casutil; 
	*promote casdata="_test_data" incaslib="CASUSER" outcaslib='CASUSER';
   droptable casdata="transistor_summary" incaslib="seford_s" quiet; 
   promote casdata="transistor_summary" incaslib="CASUSER" outcaslib='seford_s'; 

  droptable casdata="capout" incaslib="seford_s" quiet; 
   promote casdata="capout" incaslib="CASUSER" outcaslib='seford_s'; 
quit; 
