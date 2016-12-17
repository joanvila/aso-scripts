#!/bin/bash

# This script displays information about the given user


usage="Usage: infouser.sh <username>"

if [ $# -ne 1 ]; then
	echo $usage; exit 1
fi

user=$1

exists=`cat /etc/passwd | grep "^$user\>" -wc`
if [ $exists -eq 0 ]; then
	echo "The user $user does not exist"; exit 1
fi


home=`cat /etc/passwd | grep "^$user\>" | cut -d: -f6`
echo "Home: $home"

homesize=`du "$home" -sh | awk '{print $1}'`
echo "Home size: $homesize"

#otherdirs=`find / -user $user`

processes=`ps aux | grep "^$user\>" -wc`
echo "Active processes: $processes"
