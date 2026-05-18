/*
autoexec to execute for VS Code SAS extension for connection to Verde.
*/

*set sas options for the session;
options casdatalimit=4G;

*start up cas every session and pull up all global libraries;
cas;
caslib _all_ assign;

*mount a sas libname to a physcial location on the server;
libname SASFILES '/mnt/mtes-tt-file-share/data/P_FORD/library';

*make a connection to a snowflake library;
LIBNAME snowlib snow 
server="sas-rnd-containers-001.snowflakecomputing.com"
db="RND_DB"
schema="SEFORD"
user="seford"
password="xxx"
;