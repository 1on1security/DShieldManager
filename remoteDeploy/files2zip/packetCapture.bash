#!/usr/bin/env bash

# tcpdump capture for analysis, intended to be run hourly

# VARS
datestamp=$(date +"%Y-%m-%d-%H")
myLogDir=/var/log/packetCapture
pidFile=$myLogDir/PID
myPID=$(cat $pidFile)
# VAR

# kill the process ID of the prior hour
kill $myPID

# tcpdump, full capture, eth0, save to file
/usr/bin/tcpdump -ntq -s0 -i eth0 not tcp port 12222 -w $myLogDir/$datestamp.pcap & 2>/dev/null

# capture PID to a file we can use to kill the process with next hour
echo $! > $pidFile
