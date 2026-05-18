/*
this exampel uses proc http to an https endpoint and a GETmethod
debug level is optional
the temp filename writes the json response to a temporary file named resp
best option is then to use the libname json engine to read the file into a sas table
*/
%put NOTE: Running HTTPS call to API;

filename resp temp; 

/* simple public test endpoint 
set debug level to get more or less details from proc http call
1 is most detailed, 3 is least detailed*/ 
proc http 
url="https://httpbin.org/get" 
method="GET" 
out=resp;
debug level = 3;
run; 

%put HTTP Status: &SYS_PROCHTTP_STATUS_CODE &SYS_PROCHTTP_STATUS_PHRASE; 
*above macro varaibles only valid after successful proc http call;

*use libname and json engine to read the file into a nice SAS table;
libname json_lib json fileref=resp;

*extract ip and url. add some data;
data root;
    set json_lib.root;
    timestamp = datetime();
run;

*look in work.root and take a look at the root info returned from the API;