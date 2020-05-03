#!/bin/bash
LANG=fr_FR.UTF-8
re_bus='^[0-9]+$'
re_metro='^1?[0-9]b?$'
re_noct='^[nN][0-9]+$'
re_rer='^[abAB]$'
re_tram='^[tT][0-9]+'

if [[ -n $1 ]]
then
  if [[ $1 =~ $re_metro ]]
  then
    type='metros'
    code=$1
  elif [[ $1 =~ $re_bus ]]
  then
    type='buses'
    code=$1
  elif [[ $1 =~ $re_noct ]]
  then
    type='noctiliens'
    code=${1:1}
  elif [[ $1 =~ $re_rer ]]
  then
    type='rers'
    code=$1
  elif [[ $1 =~ $re_tram ]]
  then
    type='tramways'
    code=${1:1}
  else
    echo "'$1' does not correspond to an existing line name"
    exit 1
  fi
  shift
else
echo "You must provide a line number (e.g. A, B, 187, 14)"
exit 1
fi

station=$(sed -r 's/ /%2B/g' <<<$*)

url="https://api-ratp.pierre-grimaud.fr/v4/schedules/$type/$code/$station/A%2BR"

curl -X GET $url -sH  "accept: application/json" | jq -c '.result.schedules[]' | while read json
do
  # retrieve useful information
  message=$(echo $json | jq -r .message)
  destination=$(echo $json | jq -r .destination)

  # formatting
  is_time='^[0-9]+'
  if [[ $message =~ $is_time ]]
  then
    color=$(tput setaf 2)
  else
    color=$(tput setaf 1)
  fi
  nc=$(tput sgr0)
  # message="${color}$message$nc"
  printf "${color}%20s$nc\t%s\n" "$message" "$destination"
done
