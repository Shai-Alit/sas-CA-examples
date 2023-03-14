*generate example data for portability;
data alloy; 
   input pstress kCycles status$ @@; 
   cen = ( status = 'C' );  datalines;  
80.3  211.629  F    99.8   43.331  F    
80.6  200.027  F   100.1   12.076  F    
80.8   57.923  C   100.5   13.181  F    
84.3  155.000  F   113.0   18.067  F    
85.2   13.949  F   114.8   21.300  F    
85.6  112.968  C   116.4   15.616  F    
85.8  152.680  F   118.0   13.030  F    
86.4  156.725  F   118.4    8.489  F    
86.7  138.114  C   118.6   12.434  F    
87.2   56.723  F   120.4    9.750  F    
87.3  121.075  F   142.5   11.865  F    
89.7  122.372  C   144.5    6.705  F    
91.3  112.002  F   145.9    5.733  F    
;  

*set global macro variables;
%global _ODSSTYLE
        _OUTPUT_TYPE
		_DISTRIBUTION
		_GRAPH_TEMPLATE
		_SUPPRESS_TABULAR;

/* 
******************************************
Insert custom data manipulation code here
******************************************
*/



*macro to generate custom template on the fly;
%macro settemplate();

	*add template to ods path;
  	ods path(prepend) work.templat(update); 

	*create a custom template;
	proc template;  
		   define statgraph Qc.Reliability.Graphics.RegPercentiles2;    
		  notes "Regression Model Percentile Plot"; 
		  dynamic _DataPlot _PcntlPlot _XLabel _YLabel _XTicks _XTickLabels 
		 _FmtVal_1 _FmtVal_2 _TransFit _TransConf _XName _DName _XType _YType   
		 _Grid _MLGrid _SXLabel2 _SYLabel2 _PMin _PMax _LifeMin _LifeMax _SMin  
		 _SMax _GRAPH_TITLE1 _GRAPH_TITLE2 _GRAPH_FOOTNOTE1 _GRAPH_FOOTNOTE2    
		 _TITLE1_VARLABEL _TITLE1_NONE _byline_ _bytitle_ _byfootnote_; 
		  BeginGraph;   
		 if (NOT EXISTS(_TITLE1_NONE))  
		    if (EXISTS(_GRAPH_TITLE1))  
		   EntryTitle _GRAPH_TITLE1;    
		    else    
		   if (_TITLE1_VARLABEL)    
		  if (1 = 1)    
		 if (1 = 1) 
		    EntryTitle _DNAME " Percentiles for " _YLABEL;  
		 else   
		    EntryTitle _DNAME " Percentiles for " _XLABEL;  
		 endif; 
		  else  
		 if (1 = 1) 
		    EntryTitle " Percentiles for " _YLABEL; 
		 else   
		    EntryTitle " Percentiles for " _XLABEL; 
		 endif; 
		  endif;    
		   else 
		  if (1 = 1)    
		 EntryTitle _DNAME " Percentiles for " _XNAME;  
		  else  
		 EntryTitle " Percentiles for " _XNAME; 
		  endif;    
		   endif;   
		    endif;  
		 endif; 
		 if (EXISTS(_GRAPH_TITLE2)) 
		    EntryTitle _GRAPH_TITLE2;   
		 endif; 
		 layout overlay / yaxisopts=(offsetmin=.05 offsetmax=.05 label=_XLABEL  
		    shortlabel=_SXLABEL2 type=_XTYPE logopts=(tickintervalstyle=linear  
		    MINORTICKS=_MLGRID viewmin=_SMIN viewmax=_SMAX) linearopts=(    
		    TICKVALUELIST=_XTICKS TICKDISPLAYLIST=_XTICKLABELS viewmin=_SMIN    
		    viewmax=_SMAX) GRIDDISPLAY=_GRID) xaxisopts=(label=_YLABEL  
		    shortlabel=_SYLABEL2 type=_YTYPE GRIDDISPLAY=_GRID logopts=(    
		    MINORTICKS=_MLGRID viewmin=_LIFEMIN viewmax=_LIFEMAX) linearopts=(  
		    viewmin=_LIFEMIN viewmax=_LIFEMAX));    
		    if (_DATAPLOT=1)    
		   scatterplot y=XDATA x=YDATA / group=DATAGROUP name="RegScatter" markerattrs=(symbol=circlefilled size=7)  
			markeroutlineattrs=(color=black)
		  rolename=(tip1=STRESSLABEL) tip=(tip1 y) tiplabel=(tip1=  
		  "Stress" y="Life");   
		   discretelegend "RegScatter" / border=TRUE location=inside    
		  autoalign=(bottomleft bottomright topleft topright right  
		  left top bottom); 
		    endif;  
		    if (_PCNTLPLOT=1)   
		   bandplot y=XPCNTL limitupper=YPCNTL_LOWER limitlower=    
		  YPCNTL_UPPER / modelname="RegPer" datatransparency=   
		  _TransConf group=PCNTLGROUP display=(fill outline) rolename=  
		  (tip1=STRESSLABEL2 tip2=YPCNTL tip3=YPCNTL_UPPER tip4=    
		  YPCNTL_LOWER) tip=(tip1 tip2 tip3 tip4 group) tiplabel=(tip1  
		  ="Stress" tip2="Life" tip3="Upper" tip4="Lower" group=    
		  "Percentile") tipformat=(tip2=best5. tip3=best5. tip4=best5.  
		  );    
		   seriesplot y=XPCNTL x=YPCNTL / name="RegPer" group=PCNTLGROUP    
		  rolename=(tip1=STRESSLABEL2) tip=(tip1 y group) tiplabel=(    
		  tip1="Stress" y="Life" group="Percentile");   
		   discretelegend "RegPer" / title='Percentiles';   
		    endif;  
		    if (EXISTS(_FMTVAL_1))  
		   layout gridded / rows=1 columns=1 autoalign=(topright topleft    
		  bottomright bottomleft right left top bottom) border=TRUE;    
		  entry _FMTVAL_1;  
		   endlayout;   
		    endif;  
		    if (EXISTS(_FMTVAL_2))  
		   layout gridded / rows=1 columns=1 autoalign=(topright topleft    
		  bottomright bottomleft right left top bottom) border=TRUE;    
		  entry _FMTVAL_2;  
		   endlayout;   
		    endif;  
		    referenceline y=SREF / curvelabel=SREFLABEL;    
		    referenceline x=LREF / curvelabel=LREFLABEL;    
		 endlayout; 
		 if (EXISTS(_GRAPH_FOOTNOTE1))  
		    EntryFootnote _GRAPH_FOOTNOTE1; 
		 endif; 
		 if (EXISTS(_GRAPH_FOOTNOTE2))  
		    EntryFootnote _GRAPH_FOOTNOTE2; 
		 endif; 
		 if (_BYTITLE_) 
		    entrytitle _BYLINE_ / textattrs=GRAPHVALUETEXT; 
		 else   
		    if (_BYFOOTNOTE_)   
		   entryfootnote halign=left _BYLINE_;  
		    endif;  
		 endif; 
		  EndGraph; 
		   end; 
	run;  
%mend;

*macro to suppress the tabular output when requested;
%macro suppress_tables();

	%if %symexist(_SUPPRESS_TABULAR) %then 
	%do;
			%if "&_SUPPRESS_TABULAR" = "yes" %then %do;
				ods select PercentilePlot;
			%end;
	%end;
%mend;

*dynamically set macro variables based on use input;
%macro generate;

	%if %symexist(_GRAPH_TEMPLATE) %then 
	%do;
			%if "&_GRAPH_TEMPLATE" = "axis_flip" %then %do;
				%settemplate;
			%end;
	%end;

%mend;

*run the macro;
%generate; 

*set graphics options;
ods graphics on;
title "Pseudo-stress plot with probability distributions";

*run macro;
%suppress_tables;

*run reliability analysis and generate charts;
proc reliability data = alloy;  
   distribution Weibull;    
   model kcycles*cen(1) = pstress pstress*pstress / Relation = Pow Obstats; 
   logscale pstress;    
   rplot kcycles*cen(1) = pstress /  fit=regression 
                           relation = pow 
                           plotfit  10 50 90  
                           slower=60 supper=160   
                           lupper=500;    
    
   label pstress = "Pseudo-Stress"; 
   label kcycles = "Thousands of Cycles";   
run;    

*clean up;
proc template;  
   delete Qc.Reliability.Graphics.RegPercentiles2;  
run;