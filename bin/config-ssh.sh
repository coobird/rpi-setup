#!/bin/bash

# Disable passing of environment variables via SSH.
sed -i -e 's/^AcceptEnv/#AcceptEnv/' /etc/ssh/sshd_config

