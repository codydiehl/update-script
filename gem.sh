#!/bin/bash

if [ -x "$(command -v gem)" ]; then # start check gem command
	
	# variables for comparison
  upd=`gem search rubygems-update | awk '{print $2}' | sed -e 's/[(|)]//g'`
  cur=`gem -v`
	
	echo "-Checking for rubygems update-"
  if [[ "$cur" =~ "$upd" ]]; then # start version compare
    echo "ruby gem does not need to be updated..."
		printf '\n'
    echo "Current version: $cur"
  else
    echo "ruby gems needs to be updated..."
		printf '\n'
    echo "Installed Version: $cur"
    echo "Latest Version:    $upd"

		printf '\n'
		sleep 2
	
		# rubygems is out of date so ask if want to update it
		read -p "-Do you want to update rubygems? (y/n)- " -n 1 -r
		if [[ $REPLY =~ ^[Yy]$ ]]; then # start reply check

			# old version broken see: https://rubygems.org/pages/download
      if [[ "$cur" =~ "1.1"* ]] || [[ "$cur" =~ "1.2"* ]]; then # start old version check
        printf '\n'
        gem install rubygems-update
        update_rubygems
				# rehash the env once changes were made
				rbenv rehash

      else
        printf '\n'
			  gem update --system
				# rehash the env once changes were made
				rbenv rehash
				
      fi # end old version check	
	  else	
      printf '\n'
      echo "Skipping Gem Update" 
		fi # end reply check
  fi # end version compare
 
	printf '\n'
	sleep 2
	 
  # now that RubyGems is updated, lets update actual gems
  echo "-Displaying out of date ruby gems-"
  outdated=`gem outdated | column -t`

	if [ -z ${outdated+x} ]; then # start ruby gems outdated check
		echo "$outdated"

		printf '\n'

		read -p "-Do you want to update those gems? (y/n)- " -n 1 -r
		if [[ $REPLY =~ ^[Yy]$ ]]; then # start gem update reply check
			printf '\n'
			gem update

		elif [[ ! $REPLY =~ ^[Yy]$ ]]; then # check any other input reply
			printf '\n'
			echo "Skipping update of the above gems..."
		fi # end gem update reply check

	else # outdated variable is blank so skip update
		echo "Nothing to update..."
	fi # end ruby gems outdated check
	
else 
 echo "-Ruby Gems is not installed, skipping updates-"
fi # end check gem command
