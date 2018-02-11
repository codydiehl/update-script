#!/bin/bash

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
