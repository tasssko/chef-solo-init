#!/bin/bash
LOCAL_PATH="/opt/skystack"
GITHUB_PATH="https://github.com/askoudros"
PREV_DIR=`pwd`
mkdir -p $LOCAL_PATH; cd $LOCAL_PATH;
mkdir -p archives sources cookbooks init etc backups bin logs run
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

curl -s -L -o $LOCAL_PATH/archives/chef-solo-init.zip "https://github.com/askoudros/chef-solo-init/zipball/master"
cd $LOCAL_PATH/sources; unzip ../archives/chef-solo-init.zip; cd $LOCAL_PATH;
ln -s $LOCAL_PATH/sources/`ls  ../sources | grep chef-solo-init` $LOCAL_PATH/chef-solo-init;
chmod +x $LOCAL_PATH/chef-solo-init/setup; cd chef-solo-init;
	
./setup 