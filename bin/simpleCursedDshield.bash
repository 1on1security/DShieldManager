#!/usr/bin/bash

# cursedDshieldManager.bash
# A "cursed" multi-functional BASH script for managing SANS DShield Sensors
# See: https://isc.sans.edu/tools/honeypot/

# Variables live in local "VARS" file
source VARS
source FUNCTIONS

# Main script
displayBanner

main_menu() {
  dialog --keep-tite --clear --backtitle "DShield Manager Main Menu" \
    --title "DShield Manager Main Menu" \
    --menu "Choose an option:" 15 60 7 \
    1 "Download and Sync Fresh Sensor Data" \
    2 "Honeypot Logs: Import/View by Date" \
    3 "Packets: Extract/Archive Current Tarballs" \
    4 "Packets: Import to Security Onion by Date/Hour" \
    5 "Analyze TTY Logs" \
    6 "Graphing Menu" \
    7 "Utilities Menu" \
    q "Exit" 2> /tmp/dshieldManager_choice

  choice=$(cat /tmp/dshieldManager_choice)
  case $choice in
    1) /data/dshieldManager/agents/gatherAll.bash ; /data/dshieldManager/sync2_liveData.bash ;;
    2) honeypot2SQL ; sqlitebrowser $dbDir/sql/webhoneypot.sqbpro & ;;
    3) extractPackets ;;
    4) onionPackets ;;
    5) ttyMenu ;;
    6) graphFileSizes ;;
    7) utilities ;;
    q) exit 0 ;;
  esac
}

ttyMenu() {
  dialog --clear --backtitle "TTY Menu" \
    --title "TTY Menu" \
    --menu "Choose an option:" 15 50 5 \
    1 "10 Most Unique TTY by Sensors" \
    2 "Replay a TTY Log File" \
    b "Back to Main Menu" 2> /tmp/dshieldManager_choice

 choice=$(cat /tmp/dshieldManager_choice)
 case $choice in
    1) tenMostUnique ;;
    2) viewTTY ;;
    b) main_menu ;;
  esac
}

graphFileSizes() {
  dialog --clear --backtitle "Graphing Menu" \
    --title "Graphing Menu" \
    --menu "Choose an option:" 15 50 5 \
    1 "Detect Large Files (> 700 MB)" \
    2 "View Daily Honeypot Log Sizes BY SENSOR" \
    3 "View Hourly .pcap Sizes BY SENSOR" \
    4 "View Daily .pcap Tarball Sizes BY SENSOR" \
    5 "View Download File Sizes BY SENSOR" \
    6 "View TTY File Sizes BY SENSOR" \
    b "Back to Main Menu" 2> /tmp/dshieldManager_choice

  choice=$(cat /tmp/dshieldManager_choice)
  case $choice in
    1) detectLargeFiles ;;
    2) graphHoneypotLogs ;;
    3) graphPcapLogs ;;
    4) graphPacketTarballs ;;
    5) graphDownloads ;;
    6) graphTTY ;;
    b) main_menu ;;
  esac
}

utilities() {
  dialog --clear --backtitle "Utilities" \
    --title "Utilities" \
    --menu "Choose an option:" 15 50 5 \
    1 "Sensors: Flush Logs 48+ Hours Old." \
    2 "Sensors: View Status of All Sensors" \
    3 "Sensors: Execute Remote Command" \
    4 "Import/Build the _HUGE_ Database" \
    5 "Open the _HUGE_ Database" \
    b "Back to Main Menu" 2> /tmp/dshieldManager_choice

 choice=$(cat /tmp/dshieldManager_choice)
 case $choice in
    1) /data/dshieldManager/agents/flushSensors.py ;;
    2) sensorStatus ;;
    3) remoteCommand ;;
    4) time allhoneypots2SQL ;;
    5) sqlitebrowser $dbDir/sql/everywebhoneypot.sqbpro & ;;
    b) main_menu ;;
  esac
}

# Main loop
while true; do
  main_menu
done
