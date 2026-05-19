/***********************************************/
/* Update Client ID / Secret */
%let delete_client_id=username-client-id;
/***********************************************/

%let BASE_URI=%sysfunc(getoption(servicesbaseurl));

proc http
	url="&base_uri./SASLogon/oauth/clients/&delete_client_id"
	method="DELETE"
	oauth_bearer="&access_token";
	debug level=3;
run;