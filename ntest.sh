#!/bin/bash 

# check if the users system is windows, as N is not supported
if [[ "$OSTYPE" == 'msys' ]] || [[ "$OSTYPE" == 'cygwin' ]]; then
  echo "n is not supported on Windows systems"
else 

	# check if we want to fix broken permissions
	if [ ! -w "/usr/local/n/versions" ]; then
		echo "/usr/local/n/versions is not writable"
		read -p "would you like to fix permissions? (y/n) " -n 1 -r
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			printf '\n'
			sudo chown -R `whoami` /usr/local/n/versions
			sudo chmod u+w /usr/local/n/versions
		else
			echo -e '\nYou will have to use sudo every time you run n'
		fi
	fi

	install() {
	if [ ! -w "/usr/local/n/versions" ]; then
		sudo n $@
	else 
		n $@
	fi
	}


  # check for n current versions
  # change path depending on custom path set or not
  if [ -z ${N_PREFIX+x} ]; then
    vers=`find /usr/local/n/versions/node -type d | sed 's|'/usr/local/n/versions'/||g' | egrep "/[0-9]+\.[0-9]+\.[0-9]+$" | sort -k 1,1 -k 2,2n -k 3,3n -t . | awk -F/ '{print $2}'`
  else 
    vers=`find $N_PREFIX/n/versions/node -type d | sed 's|'/usr/local/n/versions'/||g' | egrep "/[0-9]+\.[0-9]+\.[0-9]+$" | sort -k 1,1 -k 2,2n -k 3,3n -t . | awk -F/ '{print $2}'`
  fi

  # print to screen current installed versions
  echo -e "Installed versions:"
	echo "$vers"
  printf '\n'

  # variables check for versions available through n
  latest=`n --latest`
  stable=`n --stable`
  lts=`n --lts`

  echo "Latest is:  $latest"
  echo "Stable is:  $stable"
  echo "LTS is:     $lts"

  printf '\n'

  # ask if user wants n latest or n stable
	# since vers is stored in a variables of all versions installed,
	# check from highest version to lowest
  case $vers in

    *$latest*)
      echo "You are currently on Latest version" ;;

    *$stable*)
      echo "You are currently on Stable version" 

      printf '\n'
      echo "Which node.js version would you like to install?"
      read -p "(Latest [L], LTS [T]) " -n 1 -r
      printf '\n'
        if [[ $REPLY =~ ^[Ll]$ ]]; then
          install latest
        elif [[ $REPLY =~ ^[Tt]$ ]]; then
          install lts
        elif [[ ! $REPLY =~ ^[LlTt]$ ]]; then
          echo "Skipping node.js update through n"
        fi

      ;;
    *$lts*)
      echo "You are currently on LTS version" 
      
      printf '\n'
      echo "Which node.js version would you like to install?"
      read -p "(Latest [L], Stable [S]) " -n 1 -r
      printf '\n'
        if [[ $REPLY =~ ^[Ll]$ ]]; then
          install latest
        elif [[ $REPLY =~ ^[Ss]$ ]]; then
          install stable 
        elif [[ ! $REPLY =~ ^[LlSs]$ ]]; then
          echo "Skipping node.js update through n"
        fi

      ;;

    *)
      if (( $(echo "$vers $latest" |  awk '{print ($1 > $2)}') )); then
        echo "How in the hell do you have this version?"
      else
        echo "You are currently on an outdated version" 
      fi

      printf '\n'
      echo "Which node.js version would you like to install?"
      read -p "(Latest [L], Stable [S], LTS [T]) " -n 1 -r
      printf '\n'
        if [[ $REPLY =~ ^[Ll]$ ]]; then
          echo "installing Latest"
          install latest 
        elif [[ $REPLY =~ ^[Ss]$ ]]; then
          echo "Install Stable"
          install stable
        elif [[ $REPLY =~ ^[Tt]$ ]]; then
          echo "Install LTS"
          install lts
        elif [[ ! $REPLY =~ ^[LlSsTt]$ ]]; then
          echo "Skipping node.js update through n"
        fi

      ;;
  esac # end version compare and update check

fi # end windows check

# set a windows only option? 
