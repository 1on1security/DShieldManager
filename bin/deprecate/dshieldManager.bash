#!/usr/bin/bash

# manageDshield.bash
# A multi-functional BASH script for managing SANS Dshield Sensors
# See: https://isc.sans.edu/tools/honeypot/

# Variables live in local "VARS" file
source VARS
source FUNCTIONS

# Main script
displayBanner

while true; do
    display_menu

    # Prompt the user for input
    read -p "Please select/type a Function and press Enter:  " choice

    case $choice in
	TEST)
		firewallMenu
		;;
	MM)
		displayBanner
		display_menu
		;;
	S)
	    fetchStatus
	    ;;
	h)
	    fetchHoneypot
	    ;;
	FW)
		fetchDShieldFirewallLog
		;;
	FWS)
		firewall2sqlite3
		;;
	H)
	    webhoneypot2sqlite3
	    ;;
	HE)
	    everyHoneypot2sqlite3
	    ;;
	HV)
		$dshieldDirectory/bin/sqlitebrowser $dbDir/sql/webhoneypot.sqbpro
		;;
	HEV)
		$dshieldDirectory/bin/sqlitebrowser $dbDir/sql/everywebhoneypot.sqbpro
		;;
	HS)
		sensorTopIP
		;;
	HES)
		sensorTopIPEvery
		;;
	HURL)
		sensorTopURL
		;;
	HERL)
		sensorTopURLEvery
		;;
	t)
        fetchTTY
        ;;
	T)
	    viewTTY
	    ;;
	d)
	    fetchDownloads
        ;;
	D)
	    extractDownloads
	    ;;
	p)
	    fetchPackets
	    ;;
	P)
	    extractPackets
	    ;;
	PU)
	    uploadPackets
	    ;;
	A)
	    fetchDownloads
	    fetchTTY
	    fetchHoneypot
		fetchDShieldFirewallLog
	    fetchPackets
	    ;;
	FF)
	    flushRemote
	    ;;
	ff)
	    flushLocal
	    ;;
	XX)
		executeRemoteCommand
		;;
    q)
        echo "Exiting."
        exit 0
        ;;
    *)
	    clear
	    printf "\n\n\n\n\n\n\n\n"
        echo "Invalid choice. Please type a selection from the menu and press Enter."
	    sleep 1
        ;;
    esac
done
