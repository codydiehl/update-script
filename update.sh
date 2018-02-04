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
  echo "Skipping Prezto Update"
fi 

# Homebrew update
if hash brew 2>/dev/null; then
  echo "Brew Exists"
  
  # brew update formulae and homebrew itself
  echo "================================"
  echo "Update homebrew itself"
  echo "================================"
  brew update

  # update brew software
  # list brew outdated formula that can be upgraded
  echo "Checking for outdated brew software that can be updated"
  brew outdated

  # brew upgrade
  brew upgrade -all


  # CLEANUP JOB
  # list old outdated formula for cleanup
  brew cleanup -n
  
  # ask if user wants to clean old outdated formula as brew leaves by default
  read -p "Do you want to clean up old outdated brew formulae? (y/n)" -n 1 -r
  echo # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]; then

    echo "You said yes"
    brew cleanup

  elif [[ ! $REPLY =~ ^[Yy]$ ]]; then

    echo "Skipping brew cleanup of outdated formulae"

    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 
    # handle exits from shell or function but dont exit interactive shell
  fi
fi
