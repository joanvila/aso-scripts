#!/bin/bash

size=0
usage="Usage: ocupacio_grups.sh [ -g <group> ] <size>"

# detecció d'opcions d'entrada: només son vàlids: <size> 600M

if [ $# -lt 1 ] || [ $# -gt 3 ]; then
	echo $usage; exit 1
fi

usuaris=()

if [ $1 = "-g" ]; then
	group=$2

	while IFS=: read name trash; do
		groups $name | cut -f2 -d: | grep -q -w "$group" && usuaris+=("$name")
	done < <(getent passwd)
fi


printf "%s " $usuaris

# TODO modificar aixo
size=$1
size_units="${size: -1}"
size="${size::-1}"

if [ $size_units = "M" ]; then
	size=$((size * 1000))
fi

for user in $usuaris; do
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

	echo $user $home $home_size $size $'\n'
	
	if [ $home_size -gt $size ]; then
		echo 'echo "Te has pasado"' >> $home/.profile
	fi
	
done
