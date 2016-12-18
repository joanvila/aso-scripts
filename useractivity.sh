#!/bin/bash

# Check the activity of a user in it's home for the last n days

usage="Usage: useractivity.sh <n days> <user real name>"

if [ $# -ne 2 ]; then
	echo $usage; exit 1
fi

ndays=$1
userrealname=$2

userhome=`cat /etc/passwd | grep $userrealname | awk -F ':' '{ print $6 }'`
username=`cat /etc/passwd | grep $userrealname | awk -F ':' '{ print $1 }'`

if [[ -z $userhome ]]; then
	echo "The user does not exist or doesn't have a home"; exit 1
fi

fileswithsize=`find $userhome -user $username -type f -mtime -$ndays -size +0 -printf "%h/%f;%s\n"`

filesmodified=0
totalsize=0

for file in $fileswithsize; do
	filesmodified=$((filesmodified + 1))
	partialsize=`echo "$file" | awk -F ';' '{ print $2 }'`
	totalsize=$((totalsize + partialsize))
done

mb=$((totalsize / 1000000))

echo "$userrealname ($username) $filesmodified files modified with total size of $mb MB"
