#!/usr/bin/with-contenv bash
# shellcheck shell=bash

if [[ "${LOG_FILE}" = "true" ]]; then
    DYNU_LOG="/config/dynu.log"
    touch "${DYNU_LOG}"
    touch /config/logrotate.status
    /usr/sbin/logrotate -s /config/logrotate.status /app/logrotate.conf
else
    DYNU_LOG="/dev/null"
fi

# Make the request to Dynu, assuming the docker container has the same address as the address you want to change
RES=$(curl -sS "http://api.dynu.com/nsid/update?myip=10.0.0.0&password=${DYNU_PASS}&hostname=${DYNU_HOST}")
case $RES in
    "badauth")
        RESULT="\e[31mauthentication error\e[0m."
        ;;
    "nochg")
        RESULT="IP update was not needed."
        ;;
    "good"*)
        IP=$(echo $RES | cut -d' ' -f2)
        RESULT="\e[32myour IP address was changed to $IP\e[0m."
        ;;
    *)
        echo "Unknown response: $RES"
        ;;
esac

echo -e "Dynu request completed at $(date), $RESULT" | tee -a "${DYNU_LOG}"