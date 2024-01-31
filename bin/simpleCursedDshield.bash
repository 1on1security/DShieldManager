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
    2 "[-nothing-]" \
    3 "Packets: Extract Tarballs" \
    4 "Packets: to Security Onion" \
    5 "Execute Remote Command on Sensors" \
    6 "Status of DShield Sensors" \
    7 "Graph File Sizes" \
    8 "Import ALL Honeypot Logs (LONG)" \
    q "Exit" 2> /tmp/dshieldManager_choice

  choice=$(cat /tmp/dshieldManager_choice)
  case $choice in
    1) honeypot2SQL ; sqlitebrowser $dbDir/sql/webhoneypot.sqbpro & ;;
    2) exit 0;;
    3) extractPackets ;;
    4) onionPackets ;;
    5) remoteCommand ;;
    6) sensorStatus ;;
    7) graphFileSizes ;;
    8) time allhoneypots2SQL ;;
    q) exit 0 ;;
  esac
}

graphFileSizes() {
  dialog --clear --backtitle "Sub Menu" \
    --title "Sub Menu" \
    --menu "Choose an option:" 15 50 5 \
    1 "Detect Large Files (>150MB)" \
    2 "View Hourly Honeypot Log Sizes BY SENSOR" \
    3 "View Hourly .pcap Sizes BY SENSOR" \
    4 "View Daily packet Tarball Sizes BY SENSOR" \
    5 "View Download File Sizes BY SENSOR" \
    6 "View TTY File Sizes BY SENSOR" \
    x "Back to Main Menu" 2> /tmp/dshieldManager_choice

  choice=$(cat /tmp/dshieldManager_choice)
  case $choice in
    1) detectLargeFiles ;;
    2) graphHoneypotLogs ;;
    3) graphPcapLogs ;;
    4) graphPacketTarballs ;;
    5) graphDownloads ;;
    6) graphTTY ;;
    x) main_menu ;;
  esac
}

# Main loop
while true; do
  main_menu
done
