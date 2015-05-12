#!/bin/bash

# Configure Avahi to allow ".local" host names locally.
# Reference: http://raspberrypi.stackexchange.com/questions/7640/rpi-not-reachable-via-its-hostname-in-lan

apt-get install avahi-daemon
if [[ $? != 0 ]]; then
  echo "*** Failed to install avahi-daemon."
  exit 1
fi

insserv avahi-daemon
if [[ $? != 0 ]]; then
  echo "*** Failed to configure boot startup for avahi-daemon."
  exit 1
fi

/etc/init.d/avahi-daemon restart
if [[ $? != 0 ]]; then
  echo "*** Failed to restart avahi-daemon."
  exit 1
fi

