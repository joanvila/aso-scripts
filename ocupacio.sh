#!/bin/bash

size=0
usage="Usage: ocupacio.sh <size>"

# detecció d'opcions d'entrada: només son vàlids: <size> 600M

if [ $# -ne 1 ]; then
	echo $usage; exit 1
fi

size=$1
size_units="${size: -1}"
size="${size::-1}"

if [ $size_units = "M" ]; then
	size=$((size * 1000))
fi

for user in `cat /etc/passwd | cut -d: -f1`; do
	home=`cat /etc/passwd | grep "^$user\>" | cut -d: -f6`

	if [ -d $home ]; then
		home_size=`LANG= du -sh $home 2>/dev/null | cut -d $'\t' -f1`
	else
		continue
	fi

	home_size_units="${home_size: -1}"
	home_size="${home_size::-1}"

	if [ $home_size_units = "M" ]; then
		home_size=$( echo "$home_size * 1000" | bc )
	fi

	home_size=${home_size%.*}

	if [ -z $home_size ]; then
		continue
	fi

	echo $user	$home_size KB $'\n'
	
	if [ $home_size -gt $size ]; then
		echo 'echo "Te has pasado"' >> $home/.profile
	fi
	
done
