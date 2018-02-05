#!/bin/bash

# NPM update
if hash npm 2>/dev/null; then

  echo "================================"
  echo " Update NPM and Packages"
  echo "================================"
	printf '\n'

	npmcheck=`npm ls -g` # check to check packages

	# update node itself
  echo "-Checking for n installation-"
  # check if n exists in listed packages
  if [[ $npmcheck =~ "─ n@" ]]; then
    echo "n is installed, continuing"
  else 
    # n isnt installed to install it globally
    echo "Installing n for more efficient updates"
    npm cache clean -f
    npm install -g n
  fi
  printf '\n'
  sleep 2

	echo "-Update node.js-"
  # now that n is installed, lets continue
  # if n is installed compare to see if node update is needed
  if [[ `node -v | cut -d v -f2` == `n --stable` ]]; then 
    echo "Node Version already stable version:"
    node -v
  else
    # node version has an available update
    echo "Node requires an update"
    echo "Current version: " 
    node -v | cut -d v -f2
    echo "Latest stable version: "
    n --stable

    # check if the user wants to update
    read -p "Do you want to update node.js to stable? (y/n)" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo "updating node.js to: " `n --stable`
      npm cache clean -f
      sudo n stable

    elif [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "Skipping node.js update"

    fi # end check for input result
  fi # end node version check

	printf '\n'
  sleep 2

  echo "-Check if npm update is needed-"
  # check if npm update is available
  if [[ `npm -v` == `npm view npm version` ]]; then
    echo "Already the current version of npm, skipping update"
  else
    echo "Newer version is available"
    printf '\n'
    echo "Current version: "
    npm -v
    printf '\n'
    echo "Available version: "
    npm view npm version

    # update npm
    read -p "Do you want to update npm? (y/n)" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo "Updating npm"
      npm install -g npm

    elif [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "Skipping npm update"
    fi

  fi

  printf '\n'
  sleep 2

  echo "-Check for npm-check-"
	# check with npm-check as its way better
	# https://github.com/dylang/npm-check
	if [[ $npmcheck =~ "npm-check@" ]]; then
		echo "npm-check is installed, continuing"
	else 
		echo "npm-check needs to be installed"
    npm install -g npm-check
	fi
  printf '\n'
  echo "-Update npm Packages-"
  # now that npm-check is installed lets run it
  npm-check -gu

fi
