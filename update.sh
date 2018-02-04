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

echo $platform


# MacOS specific

# zprezto update
if [[ "$SHELL" == *'zsh' && -e "$HOME/.zpreztorc" ]]; then
  echo "Running ZSH and prezto"
fi 

