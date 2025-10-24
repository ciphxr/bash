#!/bin/bash

echo -n "Enter network interface: "
read int

if [ -z "$int" ]; then
  echo "No interface provided. Exiting."
  exit 1
fi

echo -n "Enter target IP or MAC address (or leave empty for all): "
read target

cmd="bettercap -iface $int"

cmd+=" net.probe on; net.recon on; net.sniff on; net.show on"
cmd+="; set arp.spoof.fullduplex true"

if [ ! -z "$target" ]; then
  cmd+="; set arp.spoof.targets $target"
fi

echo "Starting Bettercap:"
echo "$cmd"
eval "$cmd"
