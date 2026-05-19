/********************************************************************/
/* Step 1: Run Code													*/
/* Step 2: Find access and refresh tokens in data or log			*/
/* Step 3: Save tokens for future use								*/
/********************************************************************/

data _null_;
	string="&client_id.:&client_secret";
 	encode=put(string,$base64x64.);
	call symput ("encode",encode);
run;

filename auth_out temp;

proc http
	url="&base_uri./SASLogon/oauth/token"
	method="POST"
	in="grant_type=authorization_code&code=&auth_code"
	out=auth_out;
	headers
		"Accept" = "application/json"
		"Content-Type" = "application/x-www-form-urlencoded"
		"Authorization" = "Basic &encode";
run;

libname auth_out json;
data tokens;
	set auth_out.root;
	call symput("access_token",access_token);
	call symput("refresh_token",refresh_token);
run;

options linesize=max;

%put &access_token;
%put &refresh_token;