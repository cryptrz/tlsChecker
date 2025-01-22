#!/bin/bash

# Check root user
if [[ $(id -u) -ne 0  ]];then
        echo "Please execute as root"
        exit 1
fi

# Check nmap
if ! command -v nmap >/dev/null 2>&1; then
        echo "nmap is required for using this program"
        exit 1
fi

# Check number of arguments
if [[ $# -ne 1 ]]; then
        echo "Usage: $0 example.com"
        exit 1
fi

# Check if argument $1 is a domain name or IP address
valid_domain='^([a-zA-Z0-9]+(-[a-zA-Z0-9]+)*\.)+[a-zA-Z]{2,}$'
valid_ip='^([0-9]{1,3}\.){3}[0-9]{1,3}$'

if [[ $1 =~ $valid_domain || $1 =~ $valid_ip ]]; then
        target=$1
        echo "Getting the information for $target, please be patient..."
else
        echo "$1 is not a valid domain name or IP address"
        exit 1
fi

# Create variables for validity date and date in 1 month from now
validity=$(nmap --script ssl-cert $target | grep "Not valid after" | cut -d ":" -f 2 | cut -d "T" -f 1)
onemonth=$(date -d "+1 month" +"%Y-%m-%d")

# Create folder is needed
if [[ ! -d "/root/tlsreports" ]]; then
        mkdir /root/tlsreports
fi

# Check validity, display the result and save it in a TXT file 
if [[ "$validity" < "$onemonth" ]]; then
        echo "Update NOW the TLS certificate for $target!" | tee /root/tlsreports/tls_validity_$1_$(date +%F)_UPDATE_NOW.txt
else
        echo "Everything is fine, the TLS certificate for $target is valid until:$validity" | tee /root/tlsreports/tls_validity_$1_$(date +%F).txt
fi
