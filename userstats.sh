#!/bin/bash

# Find the last logins information

for userline in `cat /etc/passwd`; do
	user=`echo $userline | cut -d: -f1`
	userid=`echo $userline | cut -d: -f3`

	# Get the real users
	realusers=()

	re='^[0-9]+$'
	if [[ $userid =~ $re ]]; then
		if [ $userid -gt 999 ]; then
			realusers+=($user)
		fi
	fi

	for user in "${realusers[@]}"; do
		if [[ ! -z  $user ]]; then
			# the user is not empty
			echo "User $user: total number of logins: `last $user | grep $user -wc`"
		fi
	done

done

echo ""

# Iterate logged in users to monitor their stats

for loggeduser in `last | grep "no logout" | awk '{print $1}'`; do
	processes=`ps aux | grep "^$loggeduser\>" -wc`
	cpu=`ps aux | grep $loggeduser | awk '{ sum += $3; } END { print sum; }' "$@"`

	echo "User $loggeduser: $processes processes -> $cpu % CPU"
done
