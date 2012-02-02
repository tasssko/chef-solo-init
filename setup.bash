#!/bin/bash

. functions.bash

COOKBOOK_PATH="https://github.com/askoudros"
LOCAL_PATH="/opt/skystack"

# make sure our basepath is set, it should definitely be set in the bootstrap script but no harm in doing it again
if [ ! -d $LOCAL_PATH ];then
	mkdir_opt_skystack $LOCAL_PATH
fi

#which cookbooks do we need ?
get_cookbook "apt" $LOCAL_PATH $COOKBOOK_PATH 
get_cookbook "build-essentials" $LOCAL_PATH $COOKBOOK_PATH
get_cookbook "openssl" $LOCAL_PATH $COOKBOOK_PATH
get_cookbook "apache2" $LOCAL_PATH $COOKBOOK_PATH 
get_cookbook "php5" $LOCAL_PATH $COOKBOOK_PATH 
get_cookbook "mysql" $LOCAL_PATH $COOKBOOK_PATH
get_cookbook "skystack" $LOCAL_PATH $COOKBOOK_PATH
get_cookbook "collectd" $LOCAL_PATH $COOKBOOK_PATH
get_cookbook "collectd-plugins" $LOCAL_PATH $COOKBOOK_PATH

chef_solo_config

apt-get update
apt-get -y install make unzip ruby1.8 ruby1.8-dev libruby1.8-extras rubygems gcc lsb-release subversion

install_rubygems

gem sources -a http://gems.opscode.com
gem install json chef ohai --no-ri --no-rdoc

find /var/lib -name "chef-solo" -exec ln -s '{}' /usr/bin/chef-solo \; 

chmod +x /usr/bin/chef-solo

chefdna=/opt/skystack/dna/dna.json
cat > $chefdna <<EOF
{
    "ss_monitor_fqdn": "",
    "ss_server_fqdn": "",
    "recipes": [
        "skystack::default",
        "skystack::collectd",
		"skystack::apache2",
		"skystack::php",
		"skystack::mysql"
    ],
    "sites": [
        {
            "server_name": "blog.example.com",
            "server_aliases": "blog.example.com",
            "document_root": "/var/www/vhosts/blog.example.com",
            "port": 80,
            "is_enabled": 1
        }
    ],
    "mysql_databases": [
        {
            "name": "wordpress_db",
            "user": "wordpress_user",
            "permissions": [
                "SELECT",
                "INSERT",
                "UPDATE",
                "DELETE",
                "CREATE",
                "DROP"
            ]
        }
    ],
    "skystack_php": {
        "add_extensions": [
            "mysql",
            "mcrypt",
            "xsl",
            "apc",
            "curl",
            "memcache",
            "imagick",
            "ffmpeg",
            "geoip",
            "xdebug",
            "gd",
            "ldap",
            "pgsql",
            "fpdf",
            "fileinfo",
            "sqlite3"
        ]
    }
}
EOF

 
#curl -k -o /tmp/dna.json -u $SS_APIUSER:$SS_APITOKEN $HTTP://$SS_BASE/$SS_ALIAS/servers/$SS_SERVER_ID.json?action=dna_only

#if [ -e /opt/skystack/dna/dna.json ];then
#	chef-solo -c $SKYSTACK_BOOT_PATH/etc/solo.rb -j /tmp/dna.json >> /opt/skystack/logs/chef_install 2>&1 
#fi

echo "success" > $LOCAL_PATH/run/state
