#!/usr/bin/env bash

# gather all current logs into a tarball and compress it for download and analysis

# VARS
datestamp=$(date +"%Y-%m-%d")
myLogDir=/var/log/packetCapture
dailyOutput=/pcap/

trafficLogsPID=$(cat /var/log/trafficLogs/PID)
# VARS

# kill the process ID of the currently running packet capture
echo "PID = " $trafficLogsPID
kill $trafficLogsPID

# Meat and potatoes; create a tarball of all .pcap files in $myLogDir to mounted S3 bucket
# /usr/bin/tar cfvz $dailyOutput/$datestamp.tar.gz $myLogDir/*.pcap
cd $myLogDir
/usr/bin/tar cfvz $dailyOutput/$datestamp.tar.gz *.pcap

# delete all previously captured packets
rm -f $myLogDir/*.pcap

# restart packet capture
/root/rootScripts/packetCapture.bash &2>/dev/null
