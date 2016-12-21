#!/bin/bash

usage="Usage: searchAndReplace.sh <dir> <search> <replace>"

if [ $# -ne 3 ]; then
	echo "$usage"; exit 1
fi

dir=$1
search=$2
replace=$3

replace=`find $dir -name '*.*' -exec sed -i "s/$search/$replace/g" {} \;`
