#!/bin/bash

export SKYSTACK_PATH=/opt/skystack

export SS_ALIAS=`awk '/SS_ALIAS/ {print $2}' FS=\= $SKYSTACK_PATH/etc/userdata.conf` > /dev/null 2>&1 
export SS_SERVER_ID=`awk '/SS_SERVER_ID/ {print $2}' FS=\= $SKYSTACK_PATH/etc/userdata.conf` > /dev/null 2>&1
export SS_APIUSER=`awk '/SS_APIUSER/ {print $2}' FS=\= $SKYSTACK_PATH/etc/userdata.conf` > /dev/null 2>&1 
export SS_APITOKEN=`awk '/SS_APITOKEN/ {print $2}' FS=\= $SKYSTACK_PATH/etc/userdata.conf` > /dev/null 2>&1
export SS_BASE=`awk '/SS_BASE/ {print $2}' FS=\= $SKYSTACK_PATH/etc/userdata.conf` > /dev/null 2>&1 

echo "$0: Registering hostname / ip with my.skystack.com"

curl -k -u $SS_APIUSER:$SS_APITOKEN https://$SS_BASE/$SS_ALIAS/servers/$SS_SERVER_ID.json?action=register_only

echo "$0: Registering hostname -- DONE"

exit 0
