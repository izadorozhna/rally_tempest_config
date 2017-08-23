#!/bin/bash -xe

cp ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
source /var/lib/$SOURCE_FILE

rally-manage db recreate
rally deployment create --fromenv --name=tempest
rally verify create-verifier --type tempest --name tempest-verifier --source /var/lib/tempest --version 15.0.0 --system-wide
rally verify configure-verifier --extend /var/lib/tempest_conf/$TEMPEST_CONF
rally verify  configure-verifier --override /var/lib/tempest_conf/$TEMPEST_CONF
rally verify configure-verifier --show
rally verify start --skip-list /var/lib/skip_lists/$SKIP_LIST $CUSTOM
rally verify report --type junit-xml --to ${LOG_DIR}report.xml
rally verify report --type html --to ${LOG_DIR}report.html

if [ "$DO_CLEANUP_RESOURCES" = true ] ; then
    . /var/lib/cleanup.sh
fi
