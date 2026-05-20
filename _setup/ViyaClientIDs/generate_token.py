#generates a short lived Viya token
#this token will expire within less than a day typically
#takes on the roles of the user that is currently logged in

#run from SAS Studio in Viya from a python program
#does not typically require elevated priveleges
#save the token
import os
print(os.environ['SAS_SERVICES_TOKEN'])