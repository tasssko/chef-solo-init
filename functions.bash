#!/bin/bash

mkdir_opt_skystack(){
	local local_path=$1
	mkdir -p $local_path; cd $local_path;
	mkdir -p archives sources cookbooks init etc backups bin logs run		
}


install_rubygems(){
	local version="1.8.15"
	
	cd /tmp
	wget http://production.cf.rubygems.org/rubygems/rubygems-$version.tgz
	tar xzf rubygems-$version.tgz
	cd rubygems-$version
	ruby setup.rb --no-format-executable
}

chef_solo_config(){
chefsolo=/opt/skystack/etc/solo.rb
cat > $chefsolo <<EOF
file_cache_path "/tmp/chef"
cookbook_path "/opt/skystack/cookbooks"
log_level :info
log_location "/opt/skystack/logs/chef_error.log"
ssl_verify_mode :verify_none
EOF
}

get_cookbook (){

	local cookbook=chef-$1
	local local_path=$2
	local github_path=$3
	local symlink_path=$2/cookbooks


	get_github_zipball $cookbook $local_path $github_path $symlink_path
  
}

get_github_zipball(){
	
	    local zipball=$1
        local local_path=$2
        local github_path=$3
		local symlink_path=$4

		cd $local_path; 

 		#if [ -e /usr/bin/wget ];then	
        if [ -e /usr/bin/curl ];then	
		
                # wget 
				# wget "$cookbook_path/$cookbook/zipball/master"
				
				curl -s -L -o $local_path/archives/$zipball.zip "$github_path/$zipball/zipball/master"
                cd $local_path/sources; unzip ../archives/$zipball.zip; cd $symlink_path; 
				# simple way to find cookbooks
				ln -s ../sources/`ls  ../sources | grep $zipball` $zipball
    
    	else
	
	            apt-get -y install curl
				
				#apt-get -y install wget
	 			#wget "$cookbook_path/$zipball/zipball/master"
                
				curl -s -L -o archives/$zipball.zip "$github_path/$zipball/zipball/master"
	            cd $local_path/sources; unzip ../archives/$zipball.zip; cd $local_path/cookbooks; 
				# simple way to find cookbooks
				ln -s ../sources/`ls  ../sources | grep $zipball` $zipball
        fi

}