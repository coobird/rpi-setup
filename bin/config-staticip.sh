#!/bin/bash

# Need a reference on Debian network configuration?
# Check this out:
# https://www.debian.org/doc/manuals/debian-reference/ch05.en.html

ip=$1
test -z $ip && echo "*** IP address not specified" && exit 1

grep -q 'iface eth0 inet manual' /etc/network/interfaces
if [[ $? -ne 0 ]]; then
  echo "*** Stopped. Configuration is not in an expected state."
  exit 1
fi

info=`ifconfig eth0`
netstat=`netstat -nr`

ipaddr=`echo "$info" | sed -rn 's/.+inet addr:([0-9.]+) .*$/\1/p'`
broadcast=`echo "$info"| sed -rn 's/.+Bcast:([0-9.]+) .*$/\1/p'`
netmask=`echo "$info" | sed -rn 's/.+Mask:([0-9.]+)$/\1/p'`

gateway=`echo "$netstat" | grep '^0.0.0.0' | sed -nr 's/[0-9.]+ +([0-9.]+) .+/\1/p'`
network=`echo "$netstat" | grep "$netmask" | sed -nr 's/([0-9.]+) .+/\1/p'`

v="
iface eth0 inet static\\
address $ip\\
netmask $netmask\\
network $network\\
broadcast $broadcast\\
gateway $gateway"

echo
echo === Updated /etc/network/interfaces ==== 
sed "/iface eth0 inet manual/c\\$v" /etc/network/interfaces
echo ========================================
echo

read -rsp $'Press enter to continue, or press Ctrl-C to cancel.'
echo

sed -i "/iface eth0 inet manual/c\\$v" /etc/network/interfaces
if [[ $? -eq 0 ]]; then
  echo --- Changes applied: -------------------
  cat /etc/network/interfaces
  echo ----------------------------------------
  echo "Reboot required."
else
  echo "*** Failed to change /etc/network/interfaces"
  exit 1
fi

