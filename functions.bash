#!/bin/bash

get_cookbook (){

	local cookbook=$1
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