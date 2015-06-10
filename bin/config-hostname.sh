#!/bin/bash

hostname=$1
test -z $1 && echo "*** Hostname not specified" && exit 1

echo $hostname > /etc/hostname
if [[ $? != 0 ]]; then
  echo "*** Failed to replace /etc/hostname."
  exit 1
fi

sed -i "s/127.0.1.1.*/127.0.1.1\t$hostname/" /etc/hosts
if [[ $? != 0 ]]; then
  echo "*** Failed to change /etc/hosts"
  exit 1
fi

