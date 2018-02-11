#!/bin/bash

# NPM update
if hash npm 2>/dev/null; then # check if npm exists

  echo "================================"
  echo " Update NPM and Packages"
  echo "================================"
	printf '\n'
  sleep 2

  echo "-Check if npm update is needed-"
  # check if npm update is available
  if [[ `npm -v` == `npm view npm version` ]]; then # start npm vers compare
    echo "Already the current version of npm:" `npm -v`
  else
    echo "...Newer version is available"
    printf '\n'
    echo "Current version:" `npm -v`
    echo "Available version:" `npm view npm version`
    printf '\n'
    # update npm
    read -p "Do you want to update npm to `npm view npm version`? (y/n) " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then # start reply check for npm update
      printf '\n'
      echo "...Updating npm"
      printf '\n'
      npm install -g npm

    elif [[ ! $REPLY =~ ^[Yy]$ ]]; then # skip npm update
      printf '\n'
      echo "...Skipping npm update"
    fi # end reply check for npm update
	fi # end npm vers compare

  printf '\n'
  sleep 2

	npmcheck=`npm view npm-check | head -2` # check to check packages
  echo "-Check for npm-check package-"
	# check with npm-check as its way better
	# https://github.com/dylang/npm-check
	if [[ $npmcheck =~ "{ name: 'npm-check'," ]]; then # check that npm check is installed
		echo "npm-check is already installed"
	else 
		echo "...npm-check needs to be installed"
    printf '\n' 
		# install npm-check before moving on
    npm install -g npm-check
	fi # end npm-check install
  printf '\n'
  echo "-Update npm Packages with npm-check-"
  # now that npm-check is installed lets run it
  npm-check -gu --no-emoji

  printf '\n'
  sleep 2
	echo "================================"
  echo " Update Node.JS" 
  echo "================================"
	# npm checks finished, lets move to node.js
  printf '\n'
  sleep 2

	# check if user wants to use nvm or n to manage node.js
	echo "-Preferred method to manage node.js-"
	read -p "Do you want to manage node.js with nvm? (y/n) " -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]; then # start reply checks
		printf '\n'
		echo "Using nvm to manage node.js"
		printf '\n'
		sleep 2
		
		# if nvm is installed, NVM_DIR should be set
		echo "-Checking if nvm is already installed-"
		if [ ${NVM_DIR+x} ]; then # start nvm check
			echo "nvm is already installed..."
			
		else
			echo "nvm is not installed..."
			# macos specific install
			if [[ $OSTYPE =~ "darwin" ]]; then # start OS checks 
				printf '\n'
				brew install nvm

			# linux specific install
			elif [[ "$OSTYPE" =~ "linux" ]]; then # cont. OS checks
				mkdir $HOME/.nvm
				git clone https://github.com/creationix/nvm.git $HOME/.nvm
				(cd $HOME/.nvm && git checkout $(git describe --tags `git rev-list --tags --max-count=1`))
				# Initialize nvm
				if [[ "$SHELL" =~ "zsh" ]]; then # start shell checks
					echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.zshrc
					echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> $HOME/.zshrc
					source $HOME/.nvm/nvm.sh

				elif [[ "$SHELL" =~ "bash" ]]; then # cont. shell checks
					echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.bashrc
					echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> $HOME/.bashrc
					source $HOME/.nvm/nvm.sh

				fi # end shell checks
			fi # end os checks
		fi # end nvm install check
	sleep 2

		# now that NVM is installed
		# Using NVM to update
		printf '\n'
		echo "-Install latest node.js via nvm-"

		# set temp varibles for complicated command output storage
		curr=`. $NVM_DIR/nvm.sh && nvm ls | sed 's/\x1b\[[^\x1b]*m//g' | sed -e 's/[[:alpha:]|\/\)\-\>\(|[:space:]]//g' | sed 's/[-|\*]//g' | sed '/^$/d' | tr '\012' ' '`
		vers=`. $NVM_DIR/nvm.sh && nvm ls node | head -1 | awk '{print $2}' | cut -d v -f2 | sed 's/\x1b\[[^\x1b]*m//g'`

	 if [[ "$curr" =~ "$vers" ]]; then # start nvm compare check 
			echo "Already have the latest version of node.js: $vers" 
		else 
			echo "New version of node.js is available..."
			printf '\n'
			echo "Current version of node.js:" `. $NVM_DIR/nvm.sh && nvm ls | head -1| awk '{print $2}'`
			echo "Latest version of node.js: $vers" 
			printf '\n'

			read -p "Do you want to update node.js to `. $NVM_DIR/nvm.sh && nvm ls node | head -1 | awk '{print $2}'`? (y/n) " -n 1 -r
			if [[ $REPLY =~ ^[Yy]$ ]]; then # start nvm update check
				printf '\n'
				echo "Updating node.js..."
					. $NVM_DIR/nvm.sh && nvm install node
			elif [[ ! $REPLY =~ ^[Yy]$ ]]; then # cont. nvm update check
				printf '\n'
				echo "Skipping node.js update"
			fi # end reply check for node update
		fi # end nvm compare check

	# if refuse npm, instead use n for simplicity

	elif [[ ! $REPLY =~ ^[Yy]$ ]]; then # cont. reply checks
		printf '\n'
		echo "You chose not to use nvm, lets use n"

		ncheck=`npm view n | head -2`
		# update node itself
		printf '\n'
		echo "-Checking for n package installation-"
		# check if n exists in listed packages
		if [[ $ncheck =~ "{ name: 'n'," ]]; then # start n check
			echo "n is installed, continuing"
			printf '\n'
		else 
			# n isnt installed to install it globally
			echo "Installing n for more efficient updates..."
			printf '\n'
			npm cache clean -f 2> /dev/null
			npm install -g n
		fi # end n package checks

		# Now that n is installed lets do n stuff

		# check if the users system is windows, as N is not supported
		if [[ "$OSTYPE" == 'msys' ]] || [[ "$OSTYPE" == 'cygwin' ]]; then # start windows check
			echo "n is not supported on Windows systems"
		else 

			# check if we want to fix broken permissions
			if [ ! -w "/usr/local/n/versions" ]; then # start perm check
				echo "/usr/local/n/versions is not writable"
				read -p "would you like to fix permissions? (y/n) " -n 1 -r
				if [[ $REPLY =~ ^[Yy]$ ]]; then # start perm reply check
					printf '\n'
					# assume writable by root only and set owner to user and writable
					sudo chown -R `whoami` /usr/local/n/versions
					sudo chmod u+w /usr/local/n/versions
				else
					# if the user cancels the perm change sudo is needed, see install() function
					echo -e '\nYou will have to use sudo every time you run n\n'
				fi # end perm reply check
			fi # end perm check

			# install function to be used depending on whether we fixed perms
			install() {
			if [ ! -w "/usr/local/n/versions" ]; then
				sudo n $@
			else 
				n $@
			fi
			}


			# check for n current versions
			# change path depending on custom path set or not
			if [ -z ${N_PREFIX+x} ]; then # check if user has set a custom n path

				nvers=`find /usr/local/n/versions/node -type d | sed 's|'/usr/local/n/versions'/||g' | egrep "/[0-9]+\.[0-9]+\.[0-9]+$" | sort -k 1,1 -k 2,2n -k 3,3n -t . | awk -F/ '{print $2}'`

			else # custom path is set so use it

				nvers=`find $N_PREFIX/n/versions/node -type d | sed 's|'/usr/local/n/versions'/||g' | egrep "/[0-9]+\.[0-9]+\.[0-9]+$" | sort -k 1,1 -k 2,2n -k 3,3n -t . | awk -F/ '{print $2}'`

			fi # end check custom n path
			
			echo "-Checking installed Node.js Versions-"
			# print to screen current installed versions
			echo -e "Installed versions:"
			if [ -z ${vers+x} ]; then # check to see if n has been used to install 
				echo "$nvers"
			else # n has not been used so check with node -v output.
				echo "No versions are installed through n..."
				nvers=`node -v | cut -d v -f2`
				echo "node -v : $nvers" 
			fi # end check for n usage
			printf '\n'

			# variables check for versions available through n
			latest=`n --latest`
			stable=`n --stable`
			lts=`n --lts`

			# output the variables of versions. 
			echo "-Checking available node.js versions-"
			echo "Latest is:  $latest"
			echo "Stable is:  $stable"
			echo "LTS is:     $lts"

			printf '\n'
			sleep 2

			# ask if user wants n latest or n stable
			# since vers is stored in a variables of all versions installed, lowest to highest
			# check from highest version to lowest to prevent stopping on lower than newer version
			case $nvers in

				*$latest*)
					echo "You are currently on Latest version" ;; # no need to update

				*$stable*)
					echo "You are currently on Stable version" # start check for stable

					printf '\n'
					echo "-Which node.js version would you like to install?-"
					read -p "( Latest [L], LTS [T] ) " -n 1 -r
					printf '\n'
						if [[ $REPLY =~ ^[Ll]$ ]]; then # check Latest
							install latest
						elif [[ $REPLY =~ ^[Tt]$ ]]; then # check LTS
							install lts
						elif [[ ! $REPLY =~ ^[LlTt]$ ]]; then # check any other input
							echo "Skipping node.js update through n"
						fi # end check stable

					;;
				*$lts*)
					echo "You are currently on LTS version" # start check for LTS 
					
					printf '\n'
					echo "-Which node.js version would you like to install?-"
					read -p "( Latest [L], Stable [S] ) " -n 1 -r
					printf '\n'
						if [[ $REPLY =~ ^[Ll]$ ]]; then # check latest
							install latest
						elif [[ $REPLY =~ ^[Ss]$ ]]; then # check stable
							install stable 
						elif [[ ! $REPLY =~ ^[LlSs]$ ]]; then # check any other input
							echo "Skipping node.js update through n"
						fi # end check for LTS

					;;

				*)
					# start check if the version number is higher than n --latest somehow
					if (( $(echo "$nvers $latest" |  awk '{print ($1 > $2)}') )); then
						echo "How in the hell do you have this version?" # because something is broken
					else
						echo "You are currently on an outdated version" # start outdated check
					fi # end version higher or lower than latest and not stable/latest/lts

					printf '\n'
					echo "-Which node.js version would you like to install?-"
					read -p "( Latest [L], Stable [S], LTS [T] ) " -n 1 -r
					printf '\n'
						if [[ $REPLY =~ ^[Ll]$ ]]; then # check latest
							echo "installing Latest"
							install latest 
						elif [[ $REPLY =~ ^[Ss]$ ]]; then # check stable
							echo "Install Stable"
							install stable
						elif [[ $REPLY =~ ^[Tt]$ ]]; then # check lts
							echo "Install LTS"
							install lts
						elif [[ ! $REPLY =~ ^[LlSsTt]$ ]]; then # check any other input
							echo "Skipping node.js update through n"
						fi # end outdated check

					;;
			esac # end version compare and update check

		fi # end windows check

	# set a windows only option? 
	# scoop and chocolatey install node
	# need a check for chocolatey and scoop  

	fi # end reply checks

fi # end npm check
