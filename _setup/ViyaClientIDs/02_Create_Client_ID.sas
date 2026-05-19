/********************************************************************/
/* Step 1: Optional - update length of access_token_validitity		*/
/* Step 2: Run Code													*/
/********************************************************************/

%let BASE_URI=%sysfunc(getoption(servicesbaseurl));

filename json_in temp;
proc json out=json_in pretty;
	write values "client_id" "&client_id";
	write values "client_secret" "&client_secret";
	
	write values "scope";
	write open array;
		write values "clients.read";
		write values "clients.secret";
		write values "DataBuilders";
		write values "uaa.resource";
		write values "openid";
		write values "*";
		write values "uaa.admin";
		write values "clients.admin";
		write values "scim.read";
/* 		write values "SASAdministrators"; */
		write values "CAUsersgroup";
		write values "clients.write";
		write values "scim.write";
		write values "admins";
	write close;

	write values "authorized_grant_types";
	write open array;
		write values "authorization_code";
		write values "refresh_token";
	write close;
	write values "access_token_validity" "31536000";
	write values "redirect_uri" "urn:ietf:wg:oauth:2.0:oob";
run;

filename c_out temp;
proc http
	url="&base_uri./SASLogon/oauth/clients"
	method="POST"
	in=json_in
	out=c_out
	oauth_bearer="&token";
	headers
		"Content-Type" = "application/json";
	debug level=3;
run;

libname c_out json;