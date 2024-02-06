#!/usr/bin/bash

# cursedDshieldManager.bash
# A "cursed" multi-functional BASH script for managing SANS DShield Sensors
# See: https://isc.sans.edu/tools/honeypot/

# Variables live in local "VARS" file
source VARS
source FUNCTIONS

# Main script
displayBanner

mainMenu() {

items=("Download and Sync Fresh Sensor Data" \
"Honeypot Logs: Import/View By Date" \
"Packets: Carve Packets for Sensor/Date/Time" \
"Analyze TTY Logs" "Graphing" "Utilities" "Exit")

while item=$(zenity --title="DShield Manager" --text="DShield Manager" --list  --width=800 --height=600 \
	--column="Options" "${items[@]}")
	do
		case "$item" in
			"${items[0]}") /data/dshieldManager/agents/gatherAll.bash ; /data/dshieldManager/agents/sync2_liveData.bash ; extractPackets ;;
			"${items[1]}") honeypot2SQL ; sqlitebrowser $dbDir/sql/webhoneypot.sqbpro & ;;
			"${items[2]}") carvePackets;;
			"${items[3]}") ttyMenu;;
			"${items[4]}") graphFileSizes;;
			"${items[5]}") utilities;;
			"${items[6]}") exit ;;
			*) echo "Sorry, Invalid option." ;;
		esac
	done
}

ttyMenu() {
items=("10 Most Unique TTY by Sensor" \
"Replay a TTY Log File" \
"Main Menu")

while item=$(zenity --title="TTY Menu" --text="TTY Menu" --list  --width=800 --height=600 \
	--column="Options" "${items[@]}")
	do
		case "$item" in
			"${items[0]}") tenMostUnique ;;
			"${items[1]}") viewTTY ;;
			"${items[2]}") break ;;
		esac
	done
}

graphFileSizes() {
items=("Detect Large Files (> 700 MB)" \
"View Daily Honeypot Log Sizes BY SENSOR" \
"View Hourly .pcap Sizes BY SENSOR" \
"View Daily .pcap Tarball Sizes BY SENSOR" \
"View Download File Sizes BY SENSOR" \
"View TTY File Sizes BY SENSOR" \
"Main Menu")

while item=$(zenity --title="Graphing Menu" --text="Graphing Menu" --list  --width=800 --height=600 \
	--column="Options" "${items[@]}")
	do
		case "$item" in
			"${items[0]}") detectLargeFiles ;;
			"${items[1]}") graphHoneypotLogs ;;
			"${items[2]}") graphPcapLogs ;;
			"${items[3]}") graphPacketTarballs ;;
			"${items[4]}") graphDownloads ;;
			"${items[5]}") graphTTY ;;
			"${items[6]}") break ;;			
		esac
	done
}

utilities() {

items=("Sensors: Flush Logs 48+ Hours Old" \
"Sensors: View Status of All Sensors" \
"Sensors: Execute Remote Command" \
"Import/Build the _HUGE_ Database" \
"Open the _HUGE_ Database" \
"Main Menu")

while item=$(zenity --title="Utilities Menu" --text="Utilities Menu" --list  ---width=800 --height=600 \
	--column="Options" "${items[@]}")
	do
		case "$item" in
			"${items[0]}") /data/dshieldManager/agents/flushSensors.py ;;
			"${items[1]}") sensorStatus ;;
			"${items[2]}") remoteCommand ;;
			"${items[3]}") time allhoneypots2SQL  ;;
			"${items[4]}") sqlitebrowser $dbDir/sql/everywebhoneypot.sqbpro & ;;
			"${items[5]}") break ;;	
		esac
	done	
}

# Main loop
while true; do
  mainMenu
done