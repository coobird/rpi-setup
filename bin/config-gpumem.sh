#!/bin/bash

amount=$1
test -z $1 && echo "*** Memory amount not specified" && exit 1
test $(($amount % 16)) -ne 0 && echo "*** Memory amount must be multiple of 16." && exit 1 

# Previous generations of the Raspberry Pi apparantly configured the
# memory split by changing the file name of a specific file.
# Newer Pi's edit the /boot/config.txt, and that this script will
# only support such Pi's.
# More details can be found by reading the source code for the
# raspi-config utility: https://github.com/asb/raspi-config
if [ -e /boot/start_cd.elf ]; then
  grep -q '^gpu_mem' /boot/config.txt
  if [ $? -eq 0 ]; then
    sed -i "s/gpu_mem=.*/gpu_mem=$amount/" /boot/config.txt
  else
    echo "gpu_mem=$amount" >> /boot/config.txt
  fi
else
  echo "*** This Raspberry Pi is not supported."
  exit 1
fi

