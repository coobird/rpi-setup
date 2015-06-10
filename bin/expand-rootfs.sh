#!/bin/bash

raspi-config --expand-rootfs
if [[ $? != 0 ]]; then
  echo "*** Failed to expand root filesystem."
  exit 1
fi

