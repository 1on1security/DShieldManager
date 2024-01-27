#!/bin/bash
ip=$1

echo "				ipInfo.io"
$dshieldManager/bin/skrull/ipinfo.bash $ip
echo

echo "				criminalIP"
$dshieldManager/bin/skrull/criminalIpReport.py $ip | jq .whois,.score

echo "Is Malicious:"
$dshieldManager/bin/skrull/criminalMalReport.py $ip | jq .is_malicious

echo "				virustotal reputation"
$dshieldManager/bin/vt ip $ip --format json > $reportPath/vt.json
sed -i '1d;$d' $reportPath/vt.json
cat $reportPath/vt.json | jq .reputation
echo

echo "				shodan"
shodan host $1
