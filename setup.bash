#!/bin/bash

. functions.bash

COOKBOOK_PATH="https://github.com/askoudros"
LOCAL_PATH="/opt/skystack"

if [ ! -d $LOCAL_PATH ];then
	mkdir_opt_skystack $LOCAL_PATH
fi

#which cookbooks do we need ?
get_cookbook "chef-apache2" $LOCAL_PATH $COOKBOOK_PATH 
get_cookbook "chef-php5" $LOCAL_PATH $COOKBOOK_PATH 
get_cookbook "chef-mysql" $LOCAL_PATH $COOKBOOK_PATH
get_cookbook "chef-skystack" $LOCAL_PATH $COOKBOOK_PATH
get_cookbook "chef-collectd" $LOCAL_PATH $COOKBOOK_PATH


chef_solo_config
apt-get update
apt-get -y install make unzip ruby ruby1.8 ruby1.8-dev libruby1.8-extras rubygems gcc lsb-release subversion
gem update --system

gem sources -a http://gems.opscode.com
gem install json chef ohai --no-ri --no-rdoc

find /var/lib -name "chef-solo" -exec ln -s '{}' /usr/bin/chef-solo \; 

chmod +x /usr/bin/chef-solo


#curl -k -o /tmp/dna.json -u $SS_APIUSER:$SS_APITOKEN $HTTP://$SS_BASE/$SS_ALIAS/servers/$SS_SERVER_ID.json?action=dna_only

#if [ -e /tmp/dna.json ];then
#	chef-solo -c $SKYSTACK_BOOT_PATH/etc/solo.rb -j /tmp/dna.json >> /opt/skystack/logs/chef_install 2>&1 
#fi

echo "success" > $LOCAL_PATH/userdata_state
