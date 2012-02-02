#!/bin/bash\n
# Skystack will fill in this information before sending this script to the cloud vendor
export SS_SERVER_ID=<% SS_SERVER_ID %>
export SS_STACK_ID=<% SS_STACK_ID %>

export SS_ALIAS=<% SS_ALIAS %>
export SS_HOST=<% SS_HOST %>

# Each server has its own user account that it will use to interface with Skystack.
export SS_APIUSER=<% SS_APIUSER %>
export SS_APITOKEN=<% SS_APITOKEN %>
export SS_APIPASS=<% SS_APIPASS %>

# The following metadata can be used to add functionality based on this metadata. 

export SS_BASE=<% SS_BASE %>
export SS_ROLE=<% SS_ROLE %>
export SS_ENVIRONMENT=<% SS_ENVIRONMENT %>
export SS_JURISDICTION=<% SS_JURISDICTION %>
export SS_CLOUD=<% SS_CLOUD %>

LOCAL_PATH=/opt/skystack
GITHUB_PATH=https://github.com/askoudros

PREV_DIR=`pwd`
mkdir -p $LOCAL_PATH; cd $LOCAL_PATH;
mkdir -p archives sources cookbooks init etc backups bin logs run dna
cd $PREV_DIR;

userdata=/opt/skystack/etc/userdata.conf
cat > $userdata <<EOF
SS_SERVER_ID=$SS_SERVER_ID
SS_STACK_ID=$SS_STACK_ID
SS_ALIAS=$SS_ALIAS
SS_HOST=$SS_HOST
SS_APIUSER=$SS_APIUSER
SS_APITOKEN=$SS_APITOKEN
SS_APIPASS=$SS_APIPASS
SS_BASE=$SS_BASE
SS_ROLE=$SS_ROLE
SS_ENVIRONMENT=$SS_ENVIRONMENT
SS_JURISDICTION=$SS_JURISDICTION
SS_CLOUD=$SS_CLOUD
EOF

apt-get install -y curl unzip

curl -s -L -o $LOCAL_PATH/archives/chef-solo-init.zip "https://github.com/askoudros/chef-solo-init/zipball/master"
cd $LOCAL_PATH/sources; unzip ../archives/chef-solo-init.zip; cd $LOCAL_PATH;
ln -s $LOCAL_PATH/sources/`ls sources | grep chef-solo-init` chef-solo-init; chmod +x $LOCAL_PATH/chef-solo-init/setup.bash; cd chef-solo-init;
	
`$LOCAL_PATH/chef-solo-init/setup.bash` 
 