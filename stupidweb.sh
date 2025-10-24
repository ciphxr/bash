#!/bin/bash

HARDCODED_WORDLIST="/path/to/hardcoded/wordlist.txt"

read -p "Enter wordlist directory (press enter to use default): " wordlistdir
if [ -z "$wordlistdir" ]; then
  wordlistdir="$HARDCODED_WORDLIST"
fi

read -p "Enter website URL: " website
if [ -z "$website" ]; then
  echo "No website provided"
  exit 1
fi

root_domain=$(echo "$website" | sed -e 's~http[s]*://~~g' -e 's~/.*~~g')

read -p "Choose nmap option (1-5): " nmap_option

case $nmap_option in
  1) nmap_args="-sS" ;;
  2) nmap_args="-sS -T3" ;;
  3) nmap_args="-sS -T4" ;;
  4) nmap_args="-sS -T5" ;;
  5) nmap_args="-sV -O -A -p-" ;;
  *) echo "Invalid option selected"; exit 1 ;;
esac

proxychains nmap $nmap_args $root_domain
proxychains nikto -host $root_domain
proxychains gobuster dir -u http://$root_domain -w $wordlistdir
subfinder -d $root_domain
