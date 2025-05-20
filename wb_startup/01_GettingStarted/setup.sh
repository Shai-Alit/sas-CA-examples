#!/bin/sh
#STEP 1: copy and paste this code in a terminal -> chmod -R 777 setup.sh
#STEP 2: copy and paste in the terminal -> ./setup.sh

mkdir $WORKSPACE/sasfiles
mkdir $WORKSPACE/data
mkdir $WORKSPACE/github


#clone desired repos
git -C $WORKSPACE/github clone https://github.com/sassoftware/sas-viya-workbench-examples.git 
git -C $WORKSPACE/github clone https://github.com/Shai-Alit/sas-CA-examples.git

#copy over autoexec
cp $WORKSPACE/github/sas-CA-examples/01_GettingStarted/autoexec.sas /home/sas/autoexec.sas

#install python requirements
pip install -r $WORKSPACE/github/sas-CA-examples/01_GettingStarted/requirements.txt
