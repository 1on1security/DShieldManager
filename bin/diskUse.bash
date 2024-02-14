#!/usr/bin/bash
# diskUse.bash
# dustin.decker@1on1security.com
# Fetch, calculate and display disk usage for DShield Manager

# Fetch total disk usage per directory into vars; tail grabs last line, cut removes directory string
# from the output.
liveData=$(du -h /data/dshieldManager/_liveData/ | tail -n 1 | cut -f 1)
packetFiles=$(du -h /data/dshieldManager/_packets/ | tail -n 1 | cut -f 1)
incomingFiles=$(du -h /data/dshieldManager/_incoming/ | tail -n 1 | tail -n 1 | cut -f 1)
archiveFiles=$(du -h /data/productionArchive/dshield/ | tail -n 1| tail -n 1 | cut -f 1)

# strip the "G" from each output from du for math.
num1=$(echo $liveData | sed 's/G//')
num2=$(echo $incomingFiles | sed 's/G//')
num3=$(echo $packetFiles | sed 's/G//')
num4=$(echo $archiveFiles | sed 's/G//')
# add them up
totalUse=$(echo $num1 + $num2 + $num3 + $num4 | bc)

clear
echo
echo "DShield Manager Disk Usage"
echo

echo "Live Data:		$liveData"
echo "Incoming Cache: 	$incomingFiles"
echo "Packets: 		$packetFiles"
echo "Archives:		$archiveFiles"
echo "--------------"
echo
echo $num1 + $num2 + $num3 + $num4 = $totalUse" GB Total"
echo
echo
read -n 1 -s -r -p "Press any key to continue"
clear
