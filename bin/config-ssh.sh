#!/bin/bash

# Disable passing of environment variables via SSH.
sed -i -e 's/^AcceptEnv/#AcceptEnv/' /etc/ssh/sshd_config
test $? -ne 0 && echo "*** Failed to change sshd_config file." && exit 1

sshd -t
if [[ $? -eq 0 ]]; then
  /etc/init.d/ssh reload
else
  echo "*** Stopped. Incorrect configuration for sshd."
  exit 1
fi

