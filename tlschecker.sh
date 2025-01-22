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

# Check if argument $1 is a domain name
if [[ $1 =~ ^([a-zA-Z0-9](([a-zA-Z0-9-]){0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$ ]]; then
        echo "Getting the information, please be patient..."
else
        echo "$1 is not a valid domain name"
        exit 1
fi

# Create variables
domain=$1
validity=$(nmap --script ssl-cert $domain | grep "Not valid after" | cut -d ":" -f 2 | cut -d "T" -f 1)
onemonth=$(date -d "+1 month" +"%Y-%m-%d")

# Create folder is needed
if [[ ! -d "/root/tlsreports" ]]; then
        mkdir /root/tlsreports
fi

# Check validity, display the result and save it in a TXT file 
if [[ "$validity" < "$onemonth" ]]; then
        echo "Update NOW the TLS certificate for $domain!" | tee /root/tlsreports/tls_validity_$1_$(date +%F)_UPDATE_NOW.txt
else
        echo "Everything is fine, the TLS certificate for $domain is valid until:$validity" | tee /root/tlsreports/tls_validity_$1_$(date +%F).txt
fi
