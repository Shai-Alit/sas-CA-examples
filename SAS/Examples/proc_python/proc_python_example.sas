/*
proc python example

Author: Sean T Ford
sean.ford@sas.com

*/

some sas code

proc python code



talk about submit vs terminate


/*use python so that the html responses can be properly 
formatted to print nicely in the email.*/
proc python terminate;
submit;
SAS.hideLOG(False)
import markdown;

#use SAS to get data set created above
df = SAS.sd2df('WORK.llm_temp')

full_html = ''

#generate html for each response and add it to the html that's being built
for i,r_i in df.iterrows():
    html_body = markdown.markdown(r_i['response'],extensions=['extra','sane_lists'],output_format='html5')
    if "account_name" in r_i.index:
        full_html = full_html + f' <h2>{r_i["account_name"]}</h2><br>' + html_body + '<br><br>'
    else:
        full_html = full_html + f' <h2>{r_i["sas_sltn"]} v {r_i["competitor"]}</h2><br>' + html_body + '<br><br>'

#finish up the html
# note - going line by line because I think the SAS interpreter does not like mixing f strings, ''', and "
full_html = full_html + '<p style="margin-top: 30px; font-size: 12px; color: #666;">' 
full_html = full_html + 'Generated on ' + __import__('datetime').datetime.now().strftime('%Y-%m-%d %H:%M')
full_html = full_html + '</p></body></html>'

#assign the html code as a SAS macro variable so we can use it in the email
SAS.symput('full_html',full_html)

endsubmit;
quit;