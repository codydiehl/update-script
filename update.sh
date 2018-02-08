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


# MacOS specific

# zprezto update
if [[ "$SHELL" == *'zsh' && -e "$HOME/.zpreztorc" ]]; then
  echo "================================"
  echo "Running prezto update"
  echo "================================"
  `which zsh` -i -c zprezto-update  # ~/.zprezto/init.zsh zprezto-update function

else 
  echo "Not running zsh with prezto"
  echo "Skipping Prezto Update..."
fi 
printf '\n'
sleep 2

# Homebrew update
if hash brew 2>/dev/null; then
  
  # brew update formulae and homebrew itself
  echo "================================"
  echo "Update homebrew itself"
  echo "================================"
  brew update

  sleep 2
  printf '\n'

  # update brew software
  echo "================================"
  echo "Brew Software Update"
  echo "================================"
  brew upgrade -all

  # list brew outdated formula that can be upgraded
  #echo "Checking for outdated brew software that can be updated"
  #brew outdated

  #read -p "Do you want to update the above software? (y/n)" -n 1 -r
  #if [[ $REPLY =~ ^[Yy]$ ]]; then
    #echo "You said yes"
    # brew upgrade
    #brew upgrade -all
  #elif [[ ! $REPLY =~ ^[Yy]$ ]]; then
    #echo "you said something other than yes, skipping"
  #fi
  sleep 2
  printf '\n'

  echo "================================"
  echo "Cleanup of Brew Junk"
  echo "================================"
  # CLEANUP JOB
  # list old outdated formula for cleanup
  #brew cleanup -n
  
  # ask if user wants to clean old outdated formula as brew leaves by default
  read -p "Do you want to clean up old outdated brew formulae? (y/n)" -n 1 -r
  echo # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]; then

    echo "Cleaning up old outdated packages"
    brew cleanup

  elif [[ ! $REPLY =~ ^[Yy]$ ]]; then

    echo "Skipping brew cleanup of outdated formulae"

    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 
    # handle exits from shell or function but dont exit interactive shell
  fi
else
  echo "Homebrew is not installed, skipping..."
fi

printf '\n'
sleep 2
# Finish Homebrew Update

# MacOS Built-In Software update
echo "================================"
echo " Update MacOS Software and OS"
echo "================================"

# get list of available software to update
softup=`softwareupdate -l 2>&1` # no new software logs to stderr
if [[ $softup =~ "No new software available" ]]; then
  #echo "check success"
  echo "$softup" # echo output of check
  echo "Skipping softwareupdate"
  printf '\n'
else
  echo "$softup" # echo output of available updates
  printf '\n'
  # Check if softwareupdate is wanted
  read -p "Do you want to update MacOS and software? (y/n)" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      printf '\n'
      echo "Updating OS & Mac Software"
      sudo softwareupdate -i -a

    elif [[ ! $REPLY =~ ^[Yy]$ ]]; then
      printf '\n'
      echo "Skipping Softwareupdate"

      [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 
      # handle exits from shell or function but dont exit interactive shell
    fi
fi
printf '\n'
sleep 2
# Finish MacOS Softwareupdate

# pip update
if hash pip 2>/dev/null; then

  echo "================================"
  echo " Update Python pip Packages"
  echo "================================"
	printf '\n'
	echo "Check for all installed pip packages"
	echo "____________________________________"
	# check all pip packages
	pip freeze --local | grep -v '^\-e' | cut -d = -f 1
	printf '\n'

	# ask if want to continue pip update
  read -p "Do you want to attempt to update the above pip packages? (y/n)" -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
		printf '\n'
    echo "Updating pip packages"
  	pip freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U

	# cancel pip update
  elif [[ ! $REPLY =~ ^[Yy]$ ]]; then
		printf '\n'
    echo "Skipping pip update"
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 
    # handle exits from shell or function but dont exit interactive shell
  fi
fi
printf '\n'
sleep 2
# Finish pip update







