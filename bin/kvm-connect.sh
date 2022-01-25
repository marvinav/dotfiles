#!/bin/bash

if [ -z $1 ] || [ -z $2 ] || [ $1 = '-h' ]
then
  echo 'kvm-connect.sh {{user | $U}} {{kvm name}}'
  exit 0
fi

ssh $1@$(sudo virsh domifaddr $2 | awk 'NR == 3 { print $4}' | grep -Po '([[:digit:]]{1,3}\.){3}[[:digit:]]{1,3}')
