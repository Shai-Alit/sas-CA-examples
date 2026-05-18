/*
some usefule macro variabls and system functions that are automatically assigned by Viya for you.
*/

*get the system date;
%put &SYSDATE; 

*get the currently logged in user;
%put &SYSUSERID;

*get the URL and port Viya is running from;
%put %sysfunc(getoption(servicesbaseurl));

*get the user's default home directory;
%put %SYSGET(HOME);