#!/bin/bash
token=YOUR_TOKEN_HERE
ip1=$1
ip2=$2
ip3=$3

curl "ipinfo.io/$ip1?token=$token"

if [ -n "$ip2" ]; then
    curl "ipinfo.io/$ip2?token=$token"
fi

if [ -n "$ip3" ]; then
    curl "ipinfo.io/$ip3?token=$token"
fi
