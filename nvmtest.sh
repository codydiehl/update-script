#!/bin/bash

# check if user wants to use nvm or n to manage node.js
echo "Preferred method to manage node.js"
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
vers="9.9.9"

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
	else 
		# n isnt installed to install it globally
		echo "Installing n for more efficient updates..."
		printf '\n'
		npm cache clean -f 2> /dev/null
		npm install -g n
	fi # end n package checks

  # Now that n is installed lets check stuff. 
  

fi # end reply checks

# check if the users system is windows, as N is not supported



#TODO ask if user wants n latest or n stable

#TODO check for n current version



#TODO set a windows only option? 
