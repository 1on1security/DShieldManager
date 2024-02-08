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
"" \
"View SQLITE3 Databases: Honeypot/Downloads/TTY/localDshield.log/cowrie)" \
"" \
"Packets: Carve Packets for Sensor/Date/Time" \
"" \
"Analyze TTY Logs" \
"Graphing" \
"Utilities" \
"-" \
"Exit")

while item=$(zenity --title="DShield Manager" --text="DShield Manager" --list  --width=800 --height=600 --column="Menu" "${items[@]}")
	do
		case "$item" in
			"${items[0]}") /data/dshieldManager/agents/gatherAll.bash ; /data/dshieldManager/agents/sync2_liveData.bash ; \
				extractPackets ; clear ;displayBanner ;;
			"${items[2]}") sqlite3Databases ; clear ; cat $dshieldDirectory/bin/banner.txt ;;
			"${items[4]}") carvePackets ;;
			"${items[6]}") ttyMenu ;;
			"${items[7]}") graphFileSizes ;;
			"${items[8]}") utilities ;;
			"${items[10]}") exit ;;
			*) echo "Sorry, Invalid option." ;;
		esac
	done
}

sqlite3Databases() {
items=("Honeypot Logs: Import/View By Date" \
"-" \
"View Downloads Metadata" \
"View TTY Metadata" \
"View localDshield.log Metadata" \
"View cowrie.json Metadata" \
"-" \
"Main Menu")

while item=$(zenity --title="SQLITE3 Databases" --text="SQLITE3 Databases" --list  --width=800 --height=600 --column="databases" "${items[@]}")
	do
		case "$item" in
			"${items[0]}") honeypot2SQL ; sqlitebrowser $dbDir/sql/webhoneypot.sqbpro & ;;
			"${items[2]}") downloadsDB ; sqlitebrowser $dbDir/downloads.db3 ;;
			"${items[3]}") ttyDB ; sqlitebrowser $dbDir/tty.db3 ;;
			"${items[4]}") localDshieldDB ; sqlitebrowser $dbDir/localDshield.db3 ;;
			"${items[5]}") cowrieDB ; sqlitebrowser $dbDir/cowrie.db3;;
			"${items[7]}") mainMenu ;;
		esac
	done
}

ttyMenu() {
items=("10 Most Unique TTY by Sensor" \
"Replay a TTY Log File" \
"" \
"Main Menu")

while item=$(zenity --title="TTY Menu" --text="TTY Menu" --list  --width=800 --height=600 \
	--column="TTY" "${items[@]}")
	do
		case "$item" in
			"${items[0]}") tenMostUnique ;;
			"${items[1]}") viewTTY ;;
			"${items[3]}") mainMenu ;;
		esac
	done
}

graphFileSizes() {
items=("Detect Files Larger Than 700 MB" \
"Graphiew Daily Honeypot Log Sizes BY SENSOR" \
"Graph Hourly .pcap Sizes BY SENSOR" \
"Graph Daily .pcap Tarball Sizes BY SENSOR" \
"Graph Download File Sizes BY SENSOR" \
"Graph TTY File Sizes BY SENSOR" \
"" \
"Main Menu")

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
			"${items[7]}") mainMenu ;;
		esac
	done
}

utilities() {
items=("Sensors: Flush Logs 48+ Hours Old" \
"Sensors: View Status of All Sensors" \
"Sensors: Execute Remote Command" \
"Import/Build the All Honeypot Logs Database - WARNING! Long painful process!" \
"Open the _HUGE_ Database" \
"" \
"Main Menu")

while item=$(zenity --title="Utilities" --text="Utilities" --list  --width=800 --height=600 \
	--column="Utilities" "${items[@]}")
	do
		case "$item" in
			"${items[0]}") /data/dshieldManager/agents/flushSensors.py ; clear ; cat $dshieldDirectory/bin/banner.txt  ;;
			"${items[1]}") sensorStatus ; clear ; cat $dshieldDirectory/bin/banner.txt ;;
			"${items[2]}") remoteCommand ; clear ; cat $dshieldDirectory/bin/banner.txt ;;
			"${items[3]}") time allhoneypots2SQL  ;;
			"${items[4]}") sqlitebrowser $dbDir/sql/everywebhoneypot.sqbpro & ;;
			"${items[6]}") mainMenu ;;
		esac
	done	
}

# Main loop
while true; do
  mainMenu
done
