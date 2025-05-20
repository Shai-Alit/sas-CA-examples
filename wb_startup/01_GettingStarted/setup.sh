#!/bin/sh
#first, put this code in a terminal -> chmod -R 777 setup.sh

mkdir $WORKSPACE/sasfiles
mkdir $WORKSPACE/data
mkdir $WORKSPACE/github


#clone desired repos
git -C $WORKSPACE/github clone https://github.com/sassoftware/sas-viya-workbench-examples.git 

#copy over autoexec
cp autoexec.sas /home/sas/autoexec.sas

#download desired extensions that want to manually install
wget https://github.com/microsoft/vscode-azurestorage/releases/download/v0.16.2/vscode-azurestorage-0.16.2.vsix -P $WORKSPACE/extensions

#install python requirements
pip install -r reqruirements.txt

