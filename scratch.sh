read -p "Question to ask the user? (y/n)" -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then

  elif [[ ! $REPLY =~ ^[Yy]$ ]]; then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 
    # handle exits from shell or function but dont exit interactive shell
  fi

