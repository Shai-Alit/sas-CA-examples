/***********************************************/
/* Update Client ID / Secret */
%let client_id=user-client-id;
%let client_secret=user-secret;
/* %let refresh_token=eyJhbxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1A; */
/***********************************************/

%let BASE_URI=%sysfunc(getoption(servicesbaseurl));

data _null_;
	string="&client_id.:&client_secret";
 	encode=put(string,$base64x64.);
	call symput ("encode",encode);
run;

filename new_tok temp;
proc http
	url="&base_uri./SASLogon/oauth/token?"
	method="POST"
	in="refresh_token=&refresh_token&grant_type=refresh_token"
	out=new_tok;
	headers
		"Accept" = "application/json"
		"Content-Type" = "application/x-www-form-urlencoded"
		"Authorization" = "Basic &encode";
run;

libname new_tok json;
data _null_;
	set new_tok.root;
	call symput("access_token",access_token);
	call symput("refresh_token",refresh_token);
run;

%put &access_token;
%put &refresh_token;