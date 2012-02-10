#!/bin/bash

. functions.bash

COOKBOOK_PATH="https://github.com/askoudros"
LOCAL_PATH="/opt/skystack"

# make sure our basepath is set, it should definitely be set in the bootstrap script but no harm in doing it again
if [ ! -d $LOCAL_PATH ];then
	mkdir_opt_skystack $LOCAL_PATH
fi

# register this server with Skystack (http request to server resource and action=register_only)
register_with_skystack

#read config file you could do source /opt/skystack/userdata.conf
get_config_items

#which cookbooks do we need ?
get_cookbook "apt" $LOCAL_PATH $COOKBOOK_PATH 
get_cookbook "build-essential" $LOCAL_PATH $COOKBOOK_PATH
get_cookbook "openssl" $LOCAL_PATH $COOKBOOK_PATH
get_cookbook "apache2" $LOCAL_PATH $COOKBOOK_PATH 
get_cookbook "php" $LOCAL_PATH $COOKBOOK_PATH 
get_cookbook "mysql" $LOCAL_PATH $COOKBOOK_PATH
get_cookbook "skystack" $LOCAL_PATH $COOKBOOK_PATH
get_cookbook "collectd" $LOCAL_PATH $COOKBOOK_PATH
get_cookbook "collectd-plugins" $LOCAL_PATH $COOKBOOK_PATH
get_cookbook "newrelic" $LOCAL_PATH $COOKBOOK_PATH

save_chef_solo_config

#prepare this server to run chef which will continue the installation
prepare_base_system

# we fetch the meta-data for this server
curl -u $SS_APIUSER:$SS_APITOKEN -o /opt/skystack/dna/dna.json -XGET "https://my.skystack.com/$ALIAS/servers/$SS_SERVER_ID.json?action=dna_only"

if [ -e /opt/skystack/dna/dna.json ];then
	chef-solo -c $LOCAL_PATH/etc/solo.rb -j $LOCAL_PATH/dna/dna.json >> /opt/skystack/logs/chef_install 2>&1 
fi

echo "success" > $LOCAL_PATH/run/state