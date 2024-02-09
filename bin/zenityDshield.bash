#!/usr/bin/bash

# zenityDshield.bash
# A zenity multi-functional BASH script for managing SANS DShield Sensors
# See: https://isc.sans.edu/tools/honeypot/

# Variables live in local "VARS" file
source VARS
source FUNCTIONS

# Main script
displayBanner

mainMenu() {

items=("Download and Sync Fresh Sensor Data" \
"Sensors: Flush Remote Logs: [pcap > 60 min and Logs > 2 Hours]" \
"" \
"View SQLITE3 Databases: Honeypot Logs per Date, Metadata DB" \
"" \
"Packets: Carve Packets for Sensor/Date/Time" \
"" \
"Analyze TTY Logs" \
"" \
"Graphing" \
"" \
"Utilities" \
"-" \
"Exit")

while item=$(zenity --title="DShield Manager" --text="DShield Manager" --list  --width=800 --height=600 --column="Menu" "${items[@]}")
	do
		case "$item" in
			"${items[0]}") /data/dshieldManager/agents/gatherAll.bash ; /data/dshieldManager/agents/sync2_liveData.bash ; \
				extractPackets ; clear ;displayBanner ;;
			"${items[1]}") 	/data/dshieldManager/agents/flushSensors.py ; clear ; cat $dshieldDirectory/bin/banner.txt  ;;
			"${items[3]}") sqlite3Databases ; clear ; cat $dshieldDirectory/bin/banner.txt ;;
			"${items[5]}") carvePackets ;;
			"${items[7]}") ttyMenu ;;
			"${items[9]}") graphFileSizes ;;
			"${items[11]}") utilities ;;
			"${items[13]}") exit ;;
			*) echo "Sorry, Invalid option." ;;
		esac
	done
}

sqlite3Databases() {
items=("Honeypot Logs: Import/View By Date" \
"-" \
"Metadata: Downloads/Cowrie/TTY/localDshield.log File Information")

while item=$(zenity --title="SQLITE3 Databases" --text="SQLITE3 Databases" --list  --width=800 --height=600 --column="databases" "${items[@]}")
	do
		case "$item" in
			"${items[0]}") honeypot2SQL ; $dbDir/topIPaddresses.py ; clear ; firefox http://mercury.1on1.lan/top_ips_table.html & clear ;;
			"${items[2]}") metadataDB ; sqlitebrowser $dbDir/sql/metadataDB.sqbpro & ;;
		esac
	done
}

ttyMenu() {
items=("10 Most Unique TTY by Sensor" \
"Replay a TTY Log File")

while item=$(zenity --title="TTY Menu" --text="TTY Menu" --list  --width=800 --height=600 \
	--column="TTY" "${items[@]}")
	do
		case "$item" in
			"${items[0]}") tenMostUniqueTTY ;;
			"${items[1]}") replayTTYfile ;;
		esac
	done
}

graphFileSizes() {
items=("Detect Files Larger Than 700 MB" \
"Graphiew Daily Honeypot Log Sizes BY SENSOR" \
"Graph Hourly .pcap Sizes BY SENSOR" \
"Graph Daily .pcap Tarball Sizes BY SENSOR" \
"Graph Download File Sizes BY SENSOR" \
"Graph TTY File Sizes BY SENSOR")

while item=$(zenity --title="Graphing Menu" --text="Graphing Menu" --list  --width=800 --height=600 \
	--column="Graphing" "${items[@]}")
	do
		case "$item" in
			"${items[0]}") detectLargeFiles ; clear ; cat $dshieldDirectory/bin/banner.txt ;;
			"${items[1]}") graphHoneypotLogs ; clear ; cat $dshieldDirectory/bin/banner.txt  ;;
			"${items[2]}") graphPcapLogs ; clear ; cat $dshieldDirectory/bin/banner.txt   ;;
			"${items[3]}") graphPacketTarballs ; clear ; cat $dshieldDirectory/bin/banner.txt  ;;
			"${items[4]}") graphDownloads ; clear ; cat $dshieldDirectory/bin/banner.txt  ;;
			"${items[5]}") graphTTY ; clear ; cat $dshieldDirectory/bin/banner.txt  ;;
		esac
	done
}

utilities() {
items=("Sensors: View Status of All Sensors" \
"Sensors: Execute Remote Command" \
"Import/Build the All Honeypot Logs Database - WARNING! Long painful process!" \
"Open the _HUGE_ Database")

while item=$(zenity --title="Utilities" --text="Utilities" --list  --width=800 --height=600 \
	--column="Utilities" "${items[@]}")
	do
		case "$item" in
			"${items[0]}") sensorStatus ; clear ; cat $dshieldDirectory/bin/banner.txt ;;
			"${items[1]}") remoteCommand ; clear ; cat $dshieldDirectory/bin/banner.txt ;;
			"${items[2]}") time allhoneypots2SQL  ;;
			"${items[3]}") sqlitebrowser $dbDir/sql/everywebhoneypot.sqbpro & ;;
		esac
	done	
}

# Main loop
while true; do
  mainMenu
done
