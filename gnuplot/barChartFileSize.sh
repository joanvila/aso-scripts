#!/bin/bash

usage="Usage: barChartFileSize.sh <path/to/dir>"

if [ $# -ne 1 ]; then
	echo "$usage"; exit 1	
fi

path=$1

data=`du -b $path/*`
echo "$data" > data

reversedata=`awk '{ print $2 " " $1 }' data`
echo "$reversedata" > data

plot=`gnuplot generateChart.in`

echo "Please, find your chart in this folder"
