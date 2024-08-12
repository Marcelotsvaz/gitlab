#!/usr/bin/env bash

# Packer user.
useradd --create-home --groups wheel packer
curl --silent http://169.254.169.254/latest/meta-data/public-keys/0/openssh-key > ~packer/.ssh/authorized_keys