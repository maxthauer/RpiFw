#!/bin/bash

LOCALIP=`ip addr show wlan0 | grep inet | head -1 | awk '{ print $2 }'`
service snort stop
sleep 5
sed -i '/DEBIAN_SNORT_HOME_NET/d' /etc/snort/snort.debian.conf
echo "DEBIAN_SNORT_HOME_NET=$LOCALIP" >> /etc/snort/snort.debian.conf
service snort start

