#load input data. use default input path variable assigned from node
df = SAS.sd2df(_input1)

#print info about data
print('input data shape is: ', df.shape)

#make output table
dfout = df.copy()
dfout['test'] = 1

#print info about transposed data
print('output data shape is: ', dfout.shape)

#load output dat from dataframe back to sas using default output path variable assigned from node
SAS.df2sd(dfout,_output1)

#call SAS procedure from python
SAS.submit('proc print data=_output1')