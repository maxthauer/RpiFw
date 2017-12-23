#!/bin/bash

# Script to run when the pi boots

iptables -A FORWARD -i wlan0 -o eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT
iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE

# initiate the scan for wireless networks and background the process
iwlist wlan0 scan 

# stop snort in case it runs by default
# perhaps run this after wireless network is joined
LOCALIP=`ip addr show wlan0 | grep inet | head -1 | awk '{ print $2 }'`
service snort stop
sleep 5
sed -i '/DEBIAN_SNORT_HOME_NET/d' /etc/snort/snort.debian.conf
echo "DEBIAN_SNORT_HOME_NET=$LOCALIP" >> /etc/snort/snort.debian.conf
service snort start

EXTIF="wlan0"
INTIF="eth0"
