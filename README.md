# Description
**tlschecker.sh** is compatible with **Debian-based**, **Fedora-based** and **openSUSE-based systems**. It verfies the validity of the **TLS certificate** for a given domain name or IP address.

For **Arch Linux**, please use this version: https://github.com/cryptrz/tlsChecker-btw

# Requirements
For using **tlschecker-btw.sh**, **nmap** is required (It's installed automatically if needed): 
https://nmap.org/download

# Usage
```
# First usage only
chmod +x tlschecker.sh

# Then:
sudo ./tlschecker.sh example.com
sudo ./tlschecker.sh 1.1.1.1
```
The result will tell you if the certificate is valid for at least one more month or you need to update now. The same result will be saved in a text file in /root/TLS_Reports/

```
sudo ./tlschecker.sh mozilla.org
Getting the information for mozilla.org, please be patient...
Everything is fine, the TLS certificate for mozilla.org is valid until:  2025-04-12

sudo ./tlschecker.sh fb.com
Getting the information for fb.com, please be patient...
Update NOW the TLS certificate for fb.com!
```
