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

# Check the argument
if [[ $# -ne 1 ]]; then
        echo "Usage: $0 example.com"
        exit 1
fi

echo "Getting the information, please be patient..."

# Create variables
validity=$(nmap --script ssl-cert $1 | grep "Not valid after" | cut -d ":" -f 2 | cut -d "T" -f 1)
onemonth=$(date -d "+1 month" +"%Y-%m-%d")

# Check validity
if [[ "$validity" < "$onemonth" ]]; then
        result="Update NOW the TLS certificate for $1!"
else
        result="Everything is fine, the TLS certificate for $1 is valid until:$validity"
fi

# Display the result and save it in a TXT file
echo $result | tee tls_validity_$1_$(date +%F).txt
