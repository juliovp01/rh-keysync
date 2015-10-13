#!/bin/bash
#
# Author : Julio Villarreal
# Email : julio@redhat.com
# Version : 1.0
# Purpose : Create and rotate SSH Keys. 
#


## Begin Vars

## MODULE_PATH is the installed location of rh-keysync puppet module
MODULE_PATH='/etc/puppetlabs/puppet/modules/rh-keysync'
echo $MODULE_PATH


## USER_ACCOUNTS is an array where the user account names are defined, to add more, before the ")" add the new account between " ".
USER_ACCOUNTS=("nova" "test" "cloudforms")
echo $USER_ACCOUNTS


## DIRECTORY_MASTER is a variable that will hold the path for the directory to save the files. 
DIRECTORY_MASTER=${MODULE_PATH}/ssh-keys-current
echo $DIRECTORY_MASTER


## DIRECTORY_BACK is a variable that will hold the directory where we are going to save the old key files before generating the new ones. 
DIRECTORY_BACK=${MODULE_PATH}/ssh-keys-archive
echo $DIRECTORY_BACK

## OLD_KEYS will hold the ouput of a directory listing containing current keys. 
OLD_KEYS=`ls $DIRECTORY_MASTER`


## TIMENOW is a variable that we will use to save current timestamp.
TIMENOW=`date +%d%m%y`

## LOG_FILE will host the hostfile.
LOG_FILE='/var/log/ssh_key_gen.log'

## Begin Script

#In this section we are going to the define the different functions. 
#if_create_file will create the log file if does not exist. 
if_create_file () {
	if [ ! -e "$LOG_FILE" ] ; then
		touch "$LOG_FILE"
	fi
}

#backup_files will move the current keys and add a time stamp into the DIRECTORY_BACK location.
backup_files () {
	echo "Log started for : $TIMENOW" >> $LOG_FILE
	for i in $OLD_KEYS; do
		mv $DIRECTORY_MASTER/$i $DIRECTORY_BACK/$i.$TIMENOW
		echo "Saved  old key: $i to $i.$TIMENOW on $DIRECTORY_BACK"  >> $LOG_FILE
	done
}

#generate_keys will create a key per user account stored in USER_ACCOUNTS
generate_keys () {
	exec >> $LOG_FILE
	for username in "${USER_ACCOUNTS[@]}"; do
		yes | ssh-keygen -f $DIRECTORY_MASTER/cloudkey_$username.key -N ""
	done
	echo "Keys created without issues"
}

if_create_file
backup_files
generate_keys

