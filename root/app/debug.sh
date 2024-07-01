#!/usr/bin/with-contenv bash
# shellcheck shell=bash

IFS=","
read -ra DUCKDNS <<< "${SUBDOMAINS}"
read -ra DYNU <<< "${DYNU_HOST}"
# Detect IP address of a host using Cloudflare DNS
digfunc() {
    IP=$(dig +short "$2" @1.1.1.1 | head -n 1 | sed 's/"//g') # Cloudflare DNS
    if [[ -z "${IP}" ]]; then
        IP="\e[31mINVALID\e[0m, there is an error with this host" # red
    fi
    echo -e "[$1]: "$2" has IP address of \e[33m${IP}\e[0m." # yellow
}

# Detect current address
MYIP=$(dig +short ch txt whoami.cloudflare -4 @1.1.1.1 | sed 's/"//g')
echo -e "[Debug] IP address of the server: \e[33m${MYIP}.\e[0m" # yellow

for i in "${!DUCKDNS[@]}"; do
    digfunc "DuckDNS" "${DUCKDNS[$i]}"
done

for i in "${!DYNU[@]}"; do
    digfunc "Dynu" "${DYNU[$i]}"
done