# -*- coding: utf-8 -*-
"""
Created on Thu Aug 29 11:44:49 2024

@author: seford

#From SAS Python course: https://learn.sas.com/course/view.php?id=709
"""
import swat
import pandas as pd
import sys
import os
import matplotlib.pyplot as plt
import json


#load credentials file
with open('C:/certs/creds.json') as f:
    creds = json.load(f)

#get the token
token2 = creds['verde']['token']

pd.set_option('display.max_columns',None)

print(f'Python version: {sys.version}')
#print(f'SWAT version: {swat.__version__}')

#the server. should be your Viya URL and then you have to have the "/cas-sahred-default-http/' endpoint
swat_server = 'https://verde-viya.mtes-tt.unx.sas.com/cas-shared-default-http/'

#make sure cert is installed
user = 'Sean.Ford@sas.com'
os.environ['CAS_CLIENT_SSL_CA_LIST'] = 'C:/certs/star.mtes-tt.unx.sas.com_trustedcert-expires-Oct26.pem'
os.environ['SSLCALISTLOC'] = 'C:/certs/star.mtes-tt.unx.sas.com_trustedcert-expires-Oct26.pem'

#make the connection
conn = swat.CAS(swat_server, password=token2)

#view available data sources in SAS Viya
ci = conn.caslibInfo()

#view available data source files

#view available in memory tables
ti = conn.tableInfo(caslib='casuser')

#load a table into memory and display the output
lt = conn.loadTable(path='baseball.csv',caslib='P_FORD',
                    casOut={'caslib':'casuser',
                            'replace':True})

#view available in-memory tables
ti = conn.tableInfo(caslib='casuser')

#view available files
fi = conn.fileInfo(caslib='P_FORD')

#use swat display function
display(lt,ti)

#create a reference to a table and view the object
tbl = conn.CASTable('baseball',caslib='casuser')
tbl

#view the dimensions
shape = tbl.shape

#preview the table
df_head = tbl.head()

#view column attributes
df_ci = tbl.columnInfo()

#obtain summary stats
colNames = ['nHits','Salary']
df_summary = tbl.summary(input=colNames)

#obtain missing and distinct values
maxDistinct = 10000
df_distinct = (tbl.
               distinct(maxNVals = maxDistinct)['Distinct']
               .query(f'NDistinct != {maxDistinct}'))

#plot summarized results using pandas
fig, (ax1,ax2)=plt.subplots(ncols=2,figsize=(18,6))

#ax1
(df_distinct
 .sort_values('NDistinct',ascending=False)
 .plot(kind='bar',x='Column',y='NDistinct',
       ax=ax1,
       title='Number of Distinct values in each column (10,000 value limit)'))

#ax2
(df_distinct
 .sort_values('NMiss',ascending=False)
 .plot(kind='bar',x='Column',y='NMiss',
       ax=ax2,
       title='Number of Missing Values in each Column'))

#calculate the frequency of Team in SAS Viya
df = (tbl
      .Team
      .value_counts(normalize=True))

#plot the summarized results on the client using pandas
df.plot(kind='bar',
        title='Percent of players by team')

#view total players by position

df = (tbl.
      query('Team = "New York"')
      .groupby('Position')
      .Salary.sum())

df.plot(kind='line',
        title='Total (sum) salary by Position, in team')



