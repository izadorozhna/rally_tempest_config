#!/bin/bash -xe

cp ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
source /var/lib/$SOURCE_FILE

rally-manage db recreate
rally deployment create --fromenv --name=rally

rally task start --task /var/lib/rally_scenarios/$SCENARIO.json
rally task report --html --out ${LOG_DIR}report.html
rally task report --junit --out ${LOG_DIR}report.xml

if [ "$DO_CLEANUP_RESOURCES" = true ] ; then
    . /var/lib/cleanup.sh
fi
