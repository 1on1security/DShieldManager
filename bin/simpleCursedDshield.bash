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
    h "Honeypot Log: Import/View by Date" \
    p "Packets: Extract Tarballs" \
    P "Packets: to Security Onion" \
    R "Execute Remote Command on Sensors" \
    S "Status of DShield Sensors" \
    g "Graph File Sizes" \
    q "Exit" 2> /tmp/dshieldManager_choice

  choice=$(cat /tmp/dshieldManager_choice)
  case $choice in
    h) honeypot2SQL ; sqlitebrowser $dbDir/sql/webhoneypot.sqbpro & ;;
    p) extractPackets ;;
    P) onionPackets ;;
    R) remoteCommand ;;
    S) sensorStatus ;;
    g) graphFileSizes ;;
    q) exit 0 ;;
  esac
}

graphFileSizes() {
  dialog --clear --backtitle "Sub Menu" \
    --title "Sub Menu" \
    --menu "Choose an option:" 15 50 5 \
    d "Detect Large Files (>150MB)" \
    h "View Hourly Honeypot Log Sizes BY SENSOR" \
    p "View Hourly .pcap Sizes BY SENSOR" \
    P "View Daily packet Tarball Sizes BY SENSOR" \
    D "View Download File Sizes BY SENSOR" \
    t "View TTY File Sizes BY SENSOR" \
    x "Back to Main Menu" 2> /tmp/dshieldManager_choice

  choice=$(cat /tmp/dshieldManager_choice)
  case $choice in
    d) detectLargeFiles ;;
    h) graphHoneypotLogs ;;
    p) graphPcapLogs ;;
    P) graphPacketTarballs ;;
    D) graphDownloads ;;
    t) graphTTY ;;
    x) main_menu ;;
  esac
}

# Main loop
while true; do
  main_menu
done
