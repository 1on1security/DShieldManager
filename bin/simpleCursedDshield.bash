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
	--column="Menu" "${items[@]}")
	do
		case "$item" in
			"${items[0]}") /data/dshieldManager/agents/gatherAll.bash ; /data/dshieldManager/agents/sync2_liveData.bash ; extractPackets ; clear ;displayBanner ;;
			"${items[1]}") honeypot2SQL ; sqlitebrowser $dbDir/sql/webhoneypot.sqbpro & ;;
			"${items[2]}") carvePackets ; clear ;displayBanner ;;
			"${items[3]}") ttyMenu ; clear ;displayBanner ;;
			"${items[4]}") graphFileSizes ; clear ;displayBanner ;;
			"${items[5]}") utilities ; clear ;displayBanner ;;
			"${items[6]}") exit ;;
			*) echo "Sorry, Invalid option." ;;
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
			"${items[0]}") tenMostUnique ;;
			"${items[1]}") viewTTY ;;
		esac
	done
}

graphFileSizes() {
items=("Detect Large Files (> 700 MB)" \
"View Daily Honeypot Log Sizes BY SENSOR" \
"View Hourly .pcap Sizes BY SENSOR" \
"View Daily .pcap Tarball Sizes BY SENSOR" \
"View Download File Sizes BY SENSOR" \
"View TTY File Sizes BY SENSOR")

while item=$(zenity --title="Graphing Menu" --text="Graphing Menu" --list  --width=800 --height=600 \
	--column="Graphing" "${items[@]}")
	do
		case "$item" in
			"${items[0]}") detectLargeFiles ; clear ;displayBanner ;;
			"${items[1]}") graphHoneypotLogs ; clear ;displayBanner  ;;
			"${items[2]}") graphPcapLogs ; clear ;displayBanner   ;;
			"${items[3]}") graphPacketTarballs ; clear ;displayBanner  ;;
			"${items[4]}") graphDownloads ; clear ;displayBanner  ;;
			"${items[5]}") graphTTY ; clear ;displayBanner  ;;
		esac
	done
}

utilities() {
items=("Sensors: Flush Logs 48+ Hours Old" \
"Sensors: View Status of All Sensors" \
"Sensors: Execute Remote Command" \
"Import/Build the _HUGE_ Database - WARNING!  This will chew up CPU and HURT for HOURS!" \
"Open the _HUGE_ Database")

while item=$(zenity --title="Utilities" --text="Utilities" --list  --width=800 --height=600 \
	--column="Utilities" "${items[@]}")
	do
		case "$item" in
			"${items[0]}") /data/dshieldManager/agents/flushSensors.py ; clear ;displayBanner  ;;
			"${items[1]}") sensorStatus ; clear ;displayBanner ;;
			"${items[2]}") remoteCommand ; clear ;displayBanner ;;
			"${items[3]}") time allhoneypots2SQL  ;;
			"${items[4]}") sqlitebrowser $dbDir/sql/everywebhoneypot.sqbpro & ;;
		esac
	done	
}

# Main loop
while true; do
  mainMenu
done