#!/bin/bash

if [[ $(id -u) -ne 0  ]];then
        echo "Please execute as root"
        exit 1
fi

if [[ $# -ne 1 ]]; then
        echo "Usage: $0 example.com"
        exit 1
fi

validity=$(nmap --script ssl-cert $1 | grep "Not valid after" | cut -d ":" -f 2 | cut -d "T" -f 1)
twoweeks=$(date -d "+1 month" +"%Y-%m-%d")

if [[ "$validity" < "$twoweeks" ]]; then
    echo "Update NOW!"
else
        echo "Everything is fine, the certificate is valid until:$validity"
fi
