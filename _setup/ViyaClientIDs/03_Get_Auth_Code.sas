/********************************************************************/
/* Step 1: Update client_id & secret. Run Code.												*/
/* Step 2: Copy URL from Proc Print into browser					*/
/* Step 3: Update auth_code macro variable							*/
/* Step 4: Run Code													*/
/********************************************************************/

%let BASE_URI=%sysfunc(getoption(servicesbaseurl));

%let client_id=user-client-id;
%let client_secret=user-secret;

data url;
	url=cats("&base_uri","/SASLogon/oauth/authorize?client_id=","&client_id",'&response_type=code');
run;

/*put url in browser*/
proc print data=url;
run;


/*************************************************/
/**********Update auth_code from URL above********/
/*************************************************/
%let auth_code=OWNuWr5sJQlXf5QjWi8sIut_LOmpKhQW;

