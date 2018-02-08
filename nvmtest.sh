#!/bin/bash

echo "Preferred method to manage node.js"
read -p "Do you want to manage node.js with nvm? (y/n) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then # start reply checks
	printf '\n'
	echo "Using nvm to manage node.js"
	printf '\n'
	sleep 2

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
	printf '\n'
	if [[ `. $NVM_DIR/nvm.sh && nvm ls` =~ `. $NVM_DIR/nvm.sh && nvm ls node | head -1 | awk '{print $2}'` ]]; then # nvm compare
		echo "Already on the latest version of node.js:" `. $NVM_DIR/nvm.sh && nvm ls | head -1    | awk '{print $2}'`
	else 
		echo "New version of node.js is available..."
		printf '\n'
		echo "Current version of node.js:" `. $NVM_DIR/nvm.sh && nvm ls | head -1| awk '{print $2}'`
		echo "Latest version of node.js:" `. $NVM_DIR/nvm.sh && nvm ls node | head -1 | awk '{print $2}'`
		printf '\n'

		read -p "Do you want to update node.js to `. $NVM_DIR/nvm.sh && nvm ls node | head -1 | awk '{print $2}'`? (y/n)" -n 1 -r
		if [[ $REPLY =~ ^[Yy]$ ]]; then # start nvm update check
			printf '\n'
			echo "Updating node.js..."
				. $NVM_DIR/nvm.sh && nvm install node
		elif [[ ! $REPLY =~ ^[Yy]$ ]]; then # cont. nvm update check
			printf '\n'
			echo "Skipping node.js update"
		fi # end reply check for node update
	fi # end nvm compare check



elif [[ ! $REPLY =~ ^[Yy]$ ]]; then # cont. reply checks
	echo "You chose not to use nvm, lets use n"

	ncheck=`npm view n | head -2`
	# update node itself
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
fi # end reply checks






