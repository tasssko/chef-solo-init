#!/bin/bash


prepare_base_system(){
	apt-get update
	apt-get -y install make unzip ruby1.8 ruby1.8-dev libruby1.8-extras rubygems gcc lsb-release subversion

	install_rubygems

	gem sources -a http://gems.opscode.com
	gem install json chef ohai --no-ri --no-rdoc

	find /var/lib -name "chef-solo" -exec ln -s '{}' /usr/bin/chef-solo \; 
	chmod +x /usr/bin/chef-solo
	
}

get_config_items(){
	source '/opt/skystack/etc/userdata.conf'
}

register_with_skystack(){
	local local_path=$1	
	chmod +x $local_path/chef-solo-init/register.bash
	`$local_path/chef-solo-init/register.bash`
}

mkdir_opt_skystack(){
	local local_path=$1
	mkdir -p $local_path; cd $local_path;
	mkdir -p archives sources cookbooks init etc backups bin logs run		
}


install_rubygems(){
	cd /opt/skystack/archives
	wget http://rubyforge.org/frs/download.php/38844/rubygems-update-1.2.0.gem
	gem install /opt/skystack/archives/rubygems-update-1.2.0.gem
}

save_chef_solo_config(){
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

	local cookbook=$1
	local local_path=$2
	local github_path=$3
	local symlink_path=$2/cookbooks


	get_github_zipball chef-$cookbook $cookbook $local_path $github_path $symlink_path 
  
}

get_github_zipball(){
	
	    local zipball=$1
	    local symlink_name=$2
        local local_path=$3
        local github_path=$4
		local symlink_path=$5

		cd $local_path; 

 		#if [ -e /usr/bin/wget ];then	
        if [ -e /usr/bin/curl ];then	
		
                # wget 
				# wget "$cookbook_path/$cookbook/zipball/master"
				
				curl -s -L -o $local_path/archives/$zipball.zip "$github_path/$zipball/zipball/master"
                cd $local_path/sources; unzip ../archives/$zipball.zip; cd $symlink_path; 
				# simple way to find cookbooks
				ln -s ../sources/`ls  ../sources | grep $zipball` $symlink_name

    	else
	
	            apt-get -y install curl
				
				#apt-get -y install wget
	 			#wget "$cookbook_path/$zipball/zipball/master"
                
				curl -s -L -o archives/$zipball.zip "$github_path/$zipball/zipball/master"
	            cd $local_path/sources; unzip ../archives/$zipball.zip; cd $local_path/cookbooks; 
				# simple way to find cookbooks
				ln -s ../sources/`ls  ../sources | grep $zipball` $symlink_name
        fi

}