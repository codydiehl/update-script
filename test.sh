#!/bin/bash
#set -x

pat1=`. $NVM_DIR/nvm.sh && nvm ls | sed 's/\x1b\[[^\x1b]*m//g' | sed -e 's/[[:alpha:]|\/\)\-\>\(|[:space:]]//g' | sed 's/[-|\*]//g' | sed '/^$/d' | tr '\012' ' '`
pat2=`. $NVM_DIR/nvm.sh && nvm ls node | head -1 | awk '{print $2}' | cut -d v -f2 | sed 's/\x1b\[[^\x1b]*m//g'`

#pat1=`$pat1 sed 's/$/\$/g'`
#pat2=`$pat2 sed 's/$/\$/g'`

if [[ "$pat1" =~ "$pat2"* ]]; then 
  echo 'great'
else 
  echo 'you suck'
fi

#if [[ "$pat1" == *"$pat2"* ]]; then
#  echo 'match'
#else
#  echo 'notmatching'
#fi

#echo $pat1 | grep "$pat2" > /dev/null 
#if [ $? -eq 0 ]; then
#if [[ "$pat1" = *$pat2* ]]; then
#  echo "matched"
#else
#  echo "nomatch"
#fi

#case "$pat1" in
#  *$pat2*) 
#    echo 'match'
#    ;;
#  *)
#    echo 'nomatch'
#    ;;
#esac

#if echo "$pat1" | grep -q "$pat2"
#then
#  echo "matched"
#else
#  echo "nomatch"
#fi

printf '\n'
echo -e "pat1 is \n$pat1" | cat -vet
echo -e "pat2 is \n$pat2" | cat -vet


