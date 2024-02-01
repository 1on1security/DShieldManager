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
    --menu "Choose an option:" 15 50 7 \
    1 "Honeypot Log: Import/View by Date" \
    2 "Packets: Extract Tarballs" \
    3 "Packets: to Security Onion" \
    4 "Graphing Menu" \
    5 "Utilities Menu" \
    q "Exit" 2> /tmp/dshieldManager_choice

  choice=$(cat /tmp/dshieldManager_choice)
  case $choice in
    1) honeypot2SQL ; sqlitebrowser $dbDir/sql/webhoneypot.sqbpro & ;;
    2) extractPackets ;;
    3) onionPackets ;;
    4) graphFileSizes ;;
    5) utilities ;;
    q) exit 0 ;;
  esac
}

graphFileSizes() {
  dialog --clear --backtitle "Graphing Menu" \
    --title "Graphing Menu" \
    --menu "Choose an option:" 15 50 5 \
    1 "Detect Large Files (>150MB)" \
    2 "View Hourly Honeypot Log Sizes BY SENSOR" \
    3 "View Hourly .pcap Sizes BY SENSOR" \
    4 "View Daily packet Tarball Sizes BY SENSOR" \
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
    5) sqlitebrowser $dbDir/sql/everywebhoneypot.db3.sqbpro & ;;
    b) main_menu ;;
  esac
}

# Main loop
while true; do
  main_menu
done
