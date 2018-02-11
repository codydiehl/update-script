#!/bin/bash

# get platform 
if [[ "$OSTYPE" == 'linux' ]]; then
  platform='Linux'
elif [[ "$OSTYPE" == 'freebsd'* ]]; then
  platform='FreeBSD'
elif [[ "$OSTYPE" == 'darwin'* ]]; then
  platform='MacOS'
elif [[ "$OSTYPE" == 'msys' ]]; then
  platform='MinGW'
elif [[ "$OSTYPE" == 'cygwin' ]]; then
  platform='Cygwin'
else 
  platform='Unknown'
fi

echo "Platform is $platform"

# zprezto update ++++++++++++++++++++++++++++++++++++++++++++++++

if [[ "$SHELL" == *'zsh' && -e "$HOME/.zpreztorc" ]]; then
  echo "================================"
  echo " Zsh Prezto Update"
  echo "================================"
	printf '\n'
	sleep 2
	echo "-Updating Zprezto and its Plugins-"
  `which zsh` -i -c zprezto-update  
	# ~/.zprezto/init.zsh zprezto-update function

else 
  echo "-Not running zsh with prezto framework-"
  echo "Skipping Prezto Update..."
fi 

# end zprezto update ++++++++++++++++++++++++++++++++++++++++++++

printf '\n'
sleep 2

# Homebrew update +++++++++++++++++++++++++++++++++++++++++++++++

if hash brew 2>/dev/null; then # start homebrew command check

  echo "================================"
  echo " Update HomeBrew "
  echo "================================"
  printf '\n'
  sleep 2
  
  # updating homebrew and its formulae
  echo "-Updating Homebrew Components-"
  brew update

  sleep 2
  printf '\n'

  # checking outdated software
  echo "-Checking Outdated Packages-"
  brew outdated

  sleep 2
  printf '\n'
  
  # ask user if they want to upgrade those packages

  read -p "-Do you want to update Outdated Packages? (y/n)- " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then # start reply check
    printf '\n'
    echo "Upgrading outdated packages..."
    brew upgrade

  elif [[ ! $REPLY =~ ^[Yy]$ ]]; then # any other input check
    printf '\n'
    echo "Skipping package upgrade..."
  fi # end reply check

  printf '\n'
  sleep 2

  # cleanup phase
  echo "-Listing old unnecessary packages-"
  brew cleanup -n 2>/dev/null

  printf '\n'
  sleep 2

	read -p "-Do you want to cleanup the old packages? (y/n)- " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then # start cleanup reply check
    printf '\n'
    echo "Cleaning up old packages..."
    brew cleanup

  elif [[ ! $REPLY =~ ^[Yy]$ ]]; then # any other input check
    printf '\n'
    echo "Skipping brew cleanup..."
  fi # end cleanup reply check

fi # end homebrew command check

# Finish Homebrew Update ++++++++++++++++++++++++++++++++++++++++++++

printf '\n'
sleep 2

# MacOS Built-In Software update ++++++++++++++++++++++++++++++++++++

if [[ "$OSTYPE" == 'darwin'* ]]; then # only applies to macos obviously

  echo "================================"
  echo " Update MacOS Software and OS"
  echo "================================"

  # get list of available software to update
  softup=`softwareupdate -l 2>&1` # no new software logs to stderr rather than stdout

  printf '\n'
  sleep 2

  echo "-Checking macOS Software Updates-"

  if [[ $softup =~ "No new software available" ]]; then # start no update avaialble check
    
    echo "$softup" # echo output of check
    printf '\n'
    echo "Skipping softwareupdate..."
    printf '\n'

  else # updates are available

    echo "$softup" # echo output of available updates
    printf '\n'
    sleep 2

    # Check if softwareupdate is wanted
    read -p "-Do you want to update MacOS and software? (y/n)- " -n 1 -r

      if [[ $REPLY =~ ^[Yy]$ ]]; then # start reply check
        printf '\n'
        echo "Updating OS & Mac Software..."
        sudo softwareupdate -i -a

      elif [[ ! $REPLY =~ ^[Yy]$ ]]; then # any other input check
        printf '\n'
        echo "Skipping Softwareupdate..."

      fi # end reply check for update
  fi # end no updates available check
fi # end macos check

# Finish MacOS Softwareupdate ++++++++++++++++++++++++++++++++++++++

printf '\n'
sleep 2

# pip update +++++++++++++++++++++++++++++++++++++++++++++++++++++++

if hash pip 2>/dev/null; then # check if pip command exists

  echo "================================"
  echo " Update Python pip Packages"
  echo "================================"
	printf '\n'

	echo "-Check for all installed pip packages-"

	# check all pip packages
	pip freeze --local | grep -v '^\-e' | cut -d = -f 1

	printf '\n'
  sleep 2

	# ask if want to continue pip update
  read -p "-Do you want to attempt to update the above pip packages? (y/n)- " -n 1 -r

  if [[ $REPLY =~ ^[Yy]$ ]]; then # start reply check
		printf '\n'
    echo "Updating pip packages..."
  	pip freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U

	# cancel pip update
  elif [[ ! $REPLY =~ ^[Yy]$ ]]; then # any other input check
		printf '\n'
    echo "Skipping pip update..."

  fi # end reply check
fi # end pip command check

# Finish pip update +++++++++++++++++++++++++++++++++++++++++++++++

printf '\n'
sleep 2

# start node.js and npm update ++++++++++++++++++++++++++++++++++++

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

	else # update is available

		echo "Newer version is available..."
		printf '\n'
		echo "Current version:" `npm -v`
		echo "Available version:" `npm view npm version`
		printf '\n'

		# update npm
		read -p "-Do you want to update npm to `npm view npm version`? (y/n)- " -n 1 -r

		if [[ $REPLY =~ ^[Yy]$ ]]; then # start reply check for npm update
			printf '\n'
			echo "Updating npm..."
			printf '\n'
			npm install -g npm

		elif [[ ! $REPLY =~ ^[Yy]$ ]]; then # skip npm update
			printf '\n'
			echo "Skipping npm update..."

		fi # end reply check for npm update
	fi # end npm vers compare

	printf '\n'
	sleep 2

	npmcheck=`npm view npm-check | head -2` # check to check packages

	echo "-Check for npm-check package-"
	# check with npm-check as its way better
	# https://github.com/dylang/npm-check
  
	if [[ $npmcheck =~ "{ name: 'npm-check'," ]]; then # check that npm check is installed
		echo "npm-check is already installed..."

	else # npm-check is not installed

		echo "npm-check needs to be installed..."
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
	# npm checks finished, lets move to node.js
	
	# Start node.js update +++++++++++++++++++++++++++++++++++++++ 
  
	echo "================================"
	echo " Update Node.JS" 
	echo "================================"
	printf '\n'
	sleep 2

	# check if user wants to use nvm or n to manage node.js
	echo "-Preferred method to manage node.js-"
	read -p "Do you want to manage node.js with nvm? (y/n) " -n 1 -r

	if [[ $REPLY =~ ^[Yy]$ ]]; then # start reply checks
		printf '\n'
		echo "Using nvm to manage node.js..."

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

		printf '\n'
    sleep 2

		# now that NVM is installed
		# Using NVM to update
		echo "-Install latest node.js via nvm-"

		# set temp varibles for complicated command output storage
		curr=`. $NVM_DIR/nvm.sh && nvm ls | sed 's/\x1b\[[^\x1b]*m//g' | sed -e 's/[[:alpha:]|\/\)\-\>\(|[:space:]]//g' | sed 's/[-|\*]//g' | sed '/^$/d' | tr '\012' ' '`
		vers=`. $NVM_DIR/nvm.sh && nvm ls node | head -1 | awk '{print $2}' | cut -d v -f2 | sed 's/\x1b\[[^\x1b]*m//g'`

	 if [[ "$curr" =~ "$vers" ]]; then # start nvm compare check 
			echo "Already have the latest version of node.js: $vers"

		else # update is available

			echo "New version of node.js is available..."
			printf '\n'
			echo "Current version of node.js:" `. $NVM_DIR/nvm.sh && nvm ls | head -1| awk '{print $2}'`
			echo "Latest version of node.js: $vers" 
			printf '\n'
  
      # ask update if they want to update
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
		echo "You chose not to use nvm, lets use n..."

		ncheck=`npm view n | head -2`

		# update node itself
    
		printf '\n'
    sleep 2

		echo "-Checking for n package installation-"
		# check if n exists in listed packages
		if [[ $ncheck =~ "{ name: 'n'," ]]; then # start n check
			echo "n is installed, continuing"
			printf '\n'

		else # n needs to be installed 
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

      sleep 2
      printf '\n'

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

# end node.js and npm update +++++++++++++++++++++++++++++++++++

sleep 2
printf '\n'

# start Gem Update +++++++++++++++++++++++++++++++++++++++++++++
echo "================================"
echo " Update RubyGems "
echo "================================"


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
    sleep 2

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
	
else # gem command did not exist
 echo "-Ruby Gems is not installed, skipping updates-"
fi # end check gem command

# end Gem Update

printf '\n'
sleep 2

# start vim update
echo "================================"
echo " Update Vim Plugins " 
echo "================================"


echo "-Update Vim Plugins-"
printf '\n'
echo "note: vim buffers will remain open"
echo "close when finished with :q"
printf '\n'
sleep 2

# store path for neobundle and vimplug
vimplug=`grep plug#begin ~/.vimrc | awk -F\' '{print $2}'`
neobundle=`grep neobundle#begin ~/.vimrc | awk -F\' '{print $2}'`

if [ ${vimplug+x} ]; then
  echo "vimplug is installed.."
  printf '\n'
 
  if [[ "$vimplug" =~ [~] ]]; then # start vimplug dir ~ check
    vimplug="${vimplug/\~/$HOME}"
    echo "Found VimPlug dir in: $vimplug"

  else # vimplug dir is custom
    echo "Found VimPlug dir in: $vimplug"

  fi # end vimplug dir ~ check

  printf '\n'
  sleep 2
	
	echo "-Update VimPlug-"
	printf '\n'
	# update vimplug itself
  echo "Updating VimPlug..."

	sleep 2
  vim +PlugUpgrade +qall
  printf '\n'
  sleep 2
	
	# update & install plugins
  echo "Updating vim plugins..."
	sleep 2
  vim +PlugUpdate +qall

	printf '\n'
	sleep 2

	read -p "Do you want to view the update results? (y/n) " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then # start view update reply
		vim +PlugDiff +on

  fi # end view update reply

elif [ ${neobundle+x} ]; then # start neobundle exists check
  echo "NeoBundle is installed"
  printf '\n'

  if [[ "$neobundle" =~ [~] ]]; then # start neobundle ~ check
    neobundle="${neobundle/\~/$HOME}"
    echo "Found NeoBundle dir in $neobundle"

  else
    echo "Found NeoBundle dir in $neobundle"

  fi # end neobundle ~ check

	sleep 2
  printf '\n'

  echo "-Update NeoBundle-"
  vim +NeoBundleUpdate +on

fi # end vim plugin manager checks

# end vim update
