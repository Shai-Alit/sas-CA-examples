import saspy
import os

#get the sas config file that's currently being used
cfg_loc = saspy.SAScfg

#list the configs saspy found in the path
configs = saspy.list_configs()

#alterantive (recommended for portability) - use personal config with the above options set
sas = saspy.SASsession(cfgfile="C:/Users/seford/saspy_personal_cfg.py")
#sas = saspy.SASsession(cfgfile="./saspy_personal_cfg.py")

print('reading data from sas7bdat using saspy')

#read in the default autoexec being used by the rest of SAS
with open('../../SAS/Examples/proc_http/http_api_endpoint.sas', 'r', encoding='utf-8') as file:
            code_content = file.read()

#submit to the session so autoexec for saspy session matches rest of SAS
res = sas.submit(code_content)

#print the SAS Log. alternatively, call sas.submitLOG()
print(res['LOG'])

#read data
df = sas.sd2df(table='cars', libref='sashelp')

#alternative - create the libref on the fly 
#sas.saslib('sasfiles',path=WORKSPACE+'/sasfiles')
#df = sas.sd2df(table='autoloan', libref='sasfiles')

print(df.head())

#print log of everything that has happened in this session
print(sas.saslog())

#close the session
sas.endsas()