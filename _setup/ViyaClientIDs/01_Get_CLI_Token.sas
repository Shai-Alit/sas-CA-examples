/* https://blogs.sas.com/content/sgf/2023/02/07/authentication-to-sas-viya/ */

/************************************************************************************/
/* Step 1: Update client id & secret to your values                           */
/* Step 2: Run the code                                              */
/* Step 3: Copy URL from data or proc print to browser                        */
/* Step 4: Copy updated URL from browser                                */
/* Step 5: Update macro variable of url_result with url from step 4 & rerun code    */
/************************************************************************************/

/*Update your Client ID & Seret...doesn't matter what you name*/
%let client_id=user-client-id;
%let client_secret=user-secret;

%let BASE_URI=%sysfunc(getoption(servicesbaseurl));

data url;
   url="&base_uri./SASLogon/oauth/authorize?client_id=sas.cli&response_type=token";
run;

/*Put URL in Broswer*/
proc print data=url;
run;

/*UPDATE URL RESULT STRING*/
%let url_result=https://viya.abc.com/SASLogon/out_of_band#token_type=bearer&access_token=eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHBzOi8vbG9jYWxob3N0L1NBU0xvZ29uL3Rva2VuX2tleXMiLCJraWQiOiJsZWdhY3ktdG9rZW4ta2V5IiwidHlwIjoiSldUIn0.eyJqdGkiOiIyMzk2OTQ0Y2Q0NGE0MmU1YTIzNjhiMGIxZWI4YWZkOSIsImV4dF9pZCI6InZTS3Bwa2hXc1A1ZjlQSWdjYTBWWHpHTy03RGVxYmNwNzFvcElDNzkwN2MiLCJzZXNzaW9uX3NpZyI6IjBkMDFmODQyLTE2YTktNDQ5YS05YjQzLWUwYTk4YzllNTU3ZiIsImF1dGhvcml0aWVzIjpbIkRhdGFCdWlsZGVycyIsIkFwcGxpY2F0aW9uQWRtaW5pc3RyYXRvcnMiLCJMYXVuY2hlclN1cGVyVXNlcnMiLCJFc3JpVXNlcnMiLCJEYXRhQWdlbnRBZG1pbmlzdHJhdG9ycyIsIkluZm9ybWF0aW9uQ2F0YWxvZ1VzZXJzIiwiRGF0YUFnZW50UG93ZXJVc2VycyIsIlNBU1Njb3JlVXNlcnMiLCJTQVNBZG1pbmlzdHJhdG9ycyIsIkNhdGFsb2cuU3ViamVjdE1hdHRlckV4cGVydHMiLCJVUyBTYWxlcyBURVMgQ3VzdG9tZXIgQWR2aXNvciIsIkNBU0hvc3RBY2NvdW50UmVxdWlyZWQiLCJDQVVzZXJzZ3JvdXAiXSwic3ViIjoiY2VmODY0OGEtNWIyNS00MTNkLWJkMWYtNDJhY2Y1YzBlNGNlIiwic2NvcGUiOlsiY2xpZW50cy5yZWFkIiwiY2xpZW50cy5zZWNyZXQiLCJ1YWEucmVzb3VyY2UiLCJTQVNBZG1pbmlzdHJhdG9ycyIsIm9wZW5pZCIsImNsaWVudHMud3JpdGUiLCJ1YWEuYWRtaW4iLCJjbGllbnRzLmFkbWluIiwic2NpbS53cml0ZSIsInNjaW0ucmVhZCIsInVhYS51c2VyIl0sImNsaWVudF9pZCI6InNhcy5jbGkiLCJjaWQiOiJzYXMuY2xpIiwiYXpwIjoic2FzLmNsaSIsImdyYW50X3R5cGUiOiJpbXBsaWNpdCIsInVzZXJfaWQiOiJjZWY4NjQ4YS01YjI1LTQxM2QtYmQxZi00MmFjZjVjMGU0Y2UiLCJvcmlnaW4iOiJvYXV0aCIsInVzZXJfbmFtZSI6IkJydWNlLk1pbGxzQHNhcy5jb20iLCJlbWFpbCI6IkJydWNlLk1pbGxzQHNhcy5jb20iLCJhdXRoX3RpbWUiOjE3MDk4MTcyMzEsInJldl9zaWciOiIyMGVmMDUyYyIsImlhdCI6MTcwOTgxNzY5NCwiZXhwIjoxNzA5ODUzNjk0LCJpc3MiOiJodHRwOi8vbG9jYWxob3N0L1NBU0xvZ29uL29hdXRoL3Rva2VuIiwiemlkIjoidWFhIiwiYXVkIjpbInNjaW0iLCJjbGllbnRzIiwidWFhIiwib3BlbmlkIiwic2FzLmNsaSJdfQ.THEpZgG0P-OCaDpmLAohvrcx9wmjRILGwq_Hkrr0VBPrLKwQuKI1NPrveQ3P6wsvrPq9pJAfe5vPt21iFwH1leo1eY1Zd6fZnYjJ8BRGd2800Crlgyj7u6qKw2iauCQEbnD0DFTOJ9zHYv_z5zU0A7Aw3p3Bf_UdXsaZpIt64FDEGdmxua8z3-D3-nn4PajwtXcq6bMnhxNDO-XhlA5SPR2a3JJnb-7bHZzIm-71hqhWJueH4iBL-RVlefq1ae88DChrqA_PMLMQ4806l7uEtiz8SDOZo_X4Aq8TOrcFWpY76HDIDqYfQqDz_4CBxVs54GyPhLUHevHCO8gQ414J5w&expires_in=35999&scope=clients.read%20clients.secret%20uaa.resource%20SASAdministrators%20openid%20clients.write%20uaa.admin%20clients.admin%20scim.write%20scim.read%20uaa.user&jti=2396944cd44a42e5a2368b0b1eb8afd9&revocable=false;

data new_token;
   string="&url_result";
   token=scan(scan(string,2,"&"),2,"=");
   call symputx ("token",strip(token));
run;