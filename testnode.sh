#!/bin/bash

# NPM update
if hash npm 2>/dev/null; then # check if npm exists

  echo "================================"
  echo " Update NPM and Packages"
  echo "================================"
	printf '\n'

  ncheck=`npm view n | head -2`
	# update node itself
  echo "-Checking for n package installation-"
  # check if n exists in listed packages
  if [[ $ncheck =~ "{ name: 'n'," ]]; then
    echo "n is installed, continuing"
  else 
    # n isnt installed to install it globally
    echo "Installing n for more efficient updates..."
    printf '\n'
    npm cache clean -f 2> /dev/null
    npm install -g n
  fi
  printf '\n'
  sleep 2

	echo "-Update node.js-"
  # now that n is installed, lets continue
  # if n is installed compare to see if node update is needed
  if [[ `node -v | cut -d v -f2` == `n --stable` ]]; then 
    echo "Node Version already stable version:" `node -v`
  else
    # node version has an available update
    echo "Node requires an update..."
    printf '\n'
    echo "Current version:" `node -v | cut -d v -f2`
    echo "Latest stable version:" `n --stable`
    printf '\n'
    # check if the user wants to update
    read -p "Do you want to update node.js to stable? (y/n) " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      printf '\n'
      echo "...updating node.js to:" `n --stable`
      printf '\n'
      npm cache clean -f 2> /dev/null
      sudo n stable

    elif [[ ! $REPLY =~ ^[Yy]$ ]]; then
      printf '\n'
      echo "...Skipping node.js update"

    fi # end check for input result
  fi # end node version check

	printf '\n'
  sleep 2

  echo "-Check if npm update is needed-"
  # check if npm update is available
  if [[ `npm -v` == `npm view npm version` ]]; then
    echo "Already the current version of npm:" `npm -v`
  else
    echo "...Newer version is available"
    printf '\n'
    echo "Current version:" `npm -v`
    echo "Available version:" `npm view npm version`
    printf '\n'
    # update npm
    read -p "Do you want to update npm to `npm view npm version`? (y/n) " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      printf '\n'
      echo "...Updating npm"
      printf '\n'
      npm install -g npm

    elif [[ ! $REPLY =~ ^[Yy]$ ]]; then
      printf '\n'
      echo "...Skipping npm update"
    fi

  fi

  printf '\n'
  sleep 2

	npmcheck=`npm view npm-check | head -2` # check to check packages
  echo "-Check for npm-check package-"
	# check with npm-check as its way better
	# https://github.com/dylang/npm-check
	if [[ $npmcheck =~ "{ name: 'npm-check'," ]]; then
		echo "npm-check is already installed"
	else 
		echo "...npm-check needs to be installed"
    printf '\n'
    npm install -g npm-check
	fi
  printf '\n'
  echo "-Update npm Packages with npm-check-"
  # now that npm-check is installed lets run it
  printf '\n'
  npm-check -gu --no-emoji

fi
