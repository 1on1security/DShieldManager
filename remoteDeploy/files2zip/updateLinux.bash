#!/usr/bin/bash
sudo apt install git python3-pip nano tcpdump cron -y
sudo apt update && sudo apt full-upgrade -y
sudo mkdir /logs; sudo chown dshield /logs
sudo mkdir /pcap; sudo chown dshield /pcap
sudo mkdir /var/log/packetCapture; sudo chown dshield /var/log/packetCapture
sudo mkdir /root/rootScripts

sudo mv ~/packetCapture.bash packagePackets.bash /root/rootScripts/.
sudo chmod +x /root/rootScripts/packetCapture.bash; sudo chmod +x /root/rootScripts/packagePackets.bash
sudo crontab ~/crontab
sudo cp localDshield /etc/logrotate.d/
