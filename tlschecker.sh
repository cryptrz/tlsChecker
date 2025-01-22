#!/bin/bash

# Check Linux OS
if [ ! $(uname) = "Linux"  ]; then
        echo "This script is Linux compatible only"
        exit
fi

# Check root user
if [[ $(id -u) -ne 0  ]];then
        echo "Please execute as root"
        exit 1
fi

# Check nmap
if ! command -v nmap >/dev/null 2>&1; then
        echo "nmap is required for using this program"
	# Auto-install for Debian-based distributions (Ubuntu, Mint, etc...)
	if command -v apt >/dev/null 2>&1; then
		packagemanager=apt
	# Auto-install for Fedora-based distributions (CentOS, Red Hat, etc...)
	elif command -v dnf >/dev/null 2>&1; then
                packagemanager=dnf
	# Auto-install for SUSE / openSUSE-based distributions (GeckoLinux, Kamarada, etc...)
        elif command -v zypper >/dev/null 2>&1; then
                packagemanager=zypper
	else
        	exit 1
	fi
        echo "Installing nmap..."; sleep 1
        $packagemanager install nmap -y
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
        echo -e "\nGetting the information for $target, please be patient..."
else
        echo -e "\n$1 is not a valid domain name or IP address\n"
        exit 1
fi

# Create variables for validity date and date in 1 month from now
validity=$(nmap --script ssl-cert $target | grep "Not valid after" | cut -d ":" -f 2 | cut -d "T" -f 1)
onemonth=$(date -d "+1 month" +"%Y-%m-%d")

# Create the TLS_Reports folder if needed
if [[ ! -d "/root/TLS_Reports" ]]; then
        mkdir /root/TLS_Reports
fi

# Check validity, display the result and save it in a TXT file 
if [[ "$validity" < "$onemonth" ]]; then
        echo "Update NOW the TLS certificate for $target!" | tee /root/TLS_Reports/tls_validity_$1_$(date +%F)_UPDATE_NOW.txt
else
        echo "Everything is fine, the TLS certificate for $target is valid until:$validity" | tee /root/TLS_Reports/tls_validity_$1_$(date +%F).txt
fi
