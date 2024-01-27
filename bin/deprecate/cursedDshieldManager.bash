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
    h "Manage Honeypot Logs" \
    f "Manage Firewall Logs" \
    p "Manage Packets" \
    t "Manage TTY Logs" \
    d "Manage Downloads" \
    F "Perform Get/Fetch Functions" \
    R "Remote Command" \
    S "Status of DShield Honeypots" \
    x "Exit" 2> /tmp/dshieldManager_choice

  choice=$(cat /tmp/dshieldManager_choice)
  case $choice in
    h) manage_honeypot_logs ;;
    f) manage_firewall_logs ;;
    p) manage_packets ;;
    t) manage_tty_logs ;;
    d) manage_downloads ;;
    F) fetch_functions ;;
    R) executeRemoteCommand ;;
    S) fetchStatus;;
    x) exit 0 ;;
  esac
}

manage_honeypot_logs() {
  dialog --clear --backtitle "Manage Honeypot Logs" \
    --title "Manage Honeypot Logs" \
    --menu "Choose an option:" 15 50 5 \
    d "Manage Daily Honeypot Logs" \
    A "Manage ALL Honeypot Logs" \
    x "Back to Main Menu" 2> /tmp/dshieldManager_choice

  choice=$(cat /tmp/dshieldManager_choice)
  case $choice in
    d) manage_daily_honeypot_logs ;;
    A) manage_all_honeypot_logs ;;
    x) main_menu ;;
  esac
}

manage_daily_honeypot_logs() {
  dialog --clear --backtitle "Daily Honeypot Logs" \
    --title "Daily Honeypot Logs" \
    --menu "Choose an option:" 15 50 5 \
    f "Fetch Daily Logs" \
    i "Import Daily Logs to sqlite Database" \
    v "View daily sqlite Database" \
    ip "Display Top 5 Source IPs" \
    url "Display Top 5 URL Requests" \
    x "Back to Manage Honeypot Logs" 2> /tmp/dshieldManager_choice

  choice=$(cat /tmp/dshieldManager_choice)
  case $choice in
    f) fetchHoneypot ;;
    i) honeypot2SQL ;;
    v) sqlitebrowser $dbDir/sql/webhoneypot.sqbpro &;;
    ip) sensorTopIP ;;
    url) sensorTopURL ;;
    x) manage_honeypot_logs 0 ;;
  esac
}

manage_all_honeypot_logs() {
  dialog --clear --backtitle "ALL Honeypot Logs" \
    --title "ALL Honeypot Logs" \
    --menu "Choose an option:" 15 50 5 \
    I "Import ALL Logs to sqlite Database" \
    v "View ALL sqlite Database" \
    ip "Display Top 5 Source IP's of All Time" \
    url "Display Top 5 URLs Requested of All Time" \
    x "Back to Manage Honeypot Logs" 2> /tmp/dshieldManager_choice

  choice=$(cat /tmp/dshieldManager_choice)
  case $choice in
    I) allhoneypots2SQL ;;
    v) sqlitebrowser $dbDir/sql/everywebhoneypot.sqbpro & ;;
    ip) sensorTopIPEvery ;;
    url) sensorTopURLEvery ;;
    x) manage_honeypot_logs 0 ;;
  esac
}

# Implement functions for other menu options (manage_firewall_logs, manage_packets, etc.)
manage_firewall_logs () {

  dialog --clear --backtitle "Manage Firewall Logs" \
    --title "Manage Firewall Logs" \
    --menu "Choose an option:" 15 50 5 \
    f "Fetch Daily Firewall Logs" \
    i "Import Daily Firewall Logs to sqlite" \
    v "View Daily Firewall Database" \
    a "Import ALL Firewall Logs to sqlite" \
    va "View ALL Firewall Logs Database" \
    x "Back to Main Menu" 2> /tmp/dshieldManager_choice

  choice=$(cat /tmp/dshieldManager_choice)
  case $choice in
    f) fetchDShieldFirewallLog ;;
    i) firewall2sqlite3 ;;
    v) sqlitebrowser $dbDir/sql/firewall.sqbpro &;;
    a) everyfirewall2sqlite3 ;;
    va) sqlitebrowser -r $dbDir/sql/everyfirewall.db3 &;;
    b) main_menu ;;
  esac
}

manage_packets () {
dialog --clear --backtitle "Manage Packets" \
    --title "Manage Packets" \
    --menu "Choose an option:" 15 50 5 \
    f "Fetch Packets" \
    e "Extract Packets" \
    U "Upload and Ingest Packets to Onion Server"\
    x "Back to Main Menu" 2> /tmp/dshieldManager_choice

  choice=$(cat /tmp/dshieldManager_choice)
  case $choice in
    f) fetchPackets ;;
    e) extractPackets ;;
    u) uploadPackets ;;
    x) main_menu ;;
  esac
}

manage_tty_logs () {
  dialog --clear --backtitle "Manage TTY Logs" \
    --title "Manage TTY Logs" \
    --menu "Choose an option:" 15 50 5 \
    f "Fetch TTY Logs" \
    e "Extract TTY Logs" \
    U "Replay TTY Log"\
    x "Back to Main Menu" 2> /tmp/dshieldManager_choice

  choice=$(cat /tmp/dshieldManager_choice)
  case $choice in
    f) fetchTTY ;;
    e) extractTTY ;;
    u) replayTTY ;;
    x) main_menu ;;
  esac
}

manage_downloads () {
  dialog --clear --backtitle "Manage Downloads" \
    --title "Manage Downloads" \
    --menu "Choose an option:" 15 50 5 \
    f "Fetch Downloads" \
    e "Extract Downloads" \
    U "VirusTotal"\
    x "Back to Main Menu" 2> /tmp/dshieldManager_choice

  choice=$(cat /tmp/dshieldManager_choice)
  case $choice in
    f) fetchDownloads ;;
    e) extractDownloads ;;
    u) VirusTotal ;;
    x) main_menu ;;
  esac
}

# Fetch Functions menu
fetch_functions() {
  dialog --clear --backtitle "Fetch Functions" \
    --title "Fetch Functions" \
    --menu "Choose an option:" 15 50 8 \
    h "Fetch Honeypot Logs" \
    t "Fetch TTY Logs" \
    d "Fetch Downloads" \
    f "Fetch Firewall Logs" \
    p "Fetch Packets" \
    A "Fetch ALL Logs and Packets" \
    x "Back to Main Menu" 2> /tmp/dshieldManager_choice

  choice=$(cat /tmp/dshieldManager_choice)
  # Implement actions for each choice
  case $choice in
    h) fetchHoneypot ;;
    t) fetchTTY ;;
    d) fetchDownloads ;;
    f) fetchDShieldFirewallLog ;;
    p) fetchPackets ;;
    A) fetchHoneypot; fetchTTY; fetchDownloads; fetchDShieldFirewallLog; fetchPackets;;
    x) main_menu 0 ;;
  esac

}

# Main loop
while true; do
  main_menu
done
