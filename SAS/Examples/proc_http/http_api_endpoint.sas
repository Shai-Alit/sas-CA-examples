/*
this example uses proc http to an http endpoint (ie, no SSL) and a GET method
debug level is optional
the temp filename writes the json response to a temporary file named resp
best option is then to use the libname json engine to read the file into a sas table
*/

%put NOTE: Running HTTP call to API;

filename resp temp; 

/* Neat service from Open Notify project 
set debug level to get more or less details from proc http call
1 is most detailed, 3 is least detailed*/ 
proc http 
url="http://api.open-notify.org/astros.json" 
method= "GET" 
out=resp;
debug level = 1; *optional - can remove this line;
run; 

%put HTTP Status: &SYS_PROCHTTP_STATUS_CODE &SYS_PROCHTTP_STATUS_PHRASE; 
*above macro varaibles only valid after successful proc http call;

*use libname and json engine to read the file into a nice SAS table;
libname json_lib json fileref=resp;

*extract the content we care about and add some info;
data iss_people;
    set json_lib.people;
    timestamp = datetime();
run;

*look in work.iss_people and take a look at the people currently in orbit.;

