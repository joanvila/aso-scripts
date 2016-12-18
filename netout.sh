#!/bin/bash

# Display network statistics for each network interface available

interfaces=(`ifconfig | grep flags | awk '{ print $1 }'`)
transmisions=(`ifconfig | grep "TX packets" | awk '{ print $3 }'`)

totalpackets=0

for i in "${!interfaces[@]}"; do
	# printf "%s\t%s\n" "$i" "${interfaces[$i]}"

	packetstransmited="${transmisions[$i]}"
	echo "${interfaces[$i]} $packetstransmited"

	totalpackets=$((totalpackets + packetstransmited))
done

echo "Total: $totalpackets"
