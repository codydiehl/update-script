#!/bin/bash

echo "-Update Vim Plugins-"
printf '\n'
echo "note: vim buffers will remain open"
echo "close when finished with :q"
printf '\n'

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
  printf '\n'

  echo "-Update NeoBundle-"
	sleep 2
  vim +NeoBundleUpdate +on

fi # end vim plugin manager checks
