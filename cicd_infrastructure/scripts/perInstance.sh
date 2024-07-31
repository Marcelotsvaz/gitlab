#! /usr/bin/env bash

set -o errexit
echo 'Starting Instance Configuration Script...'



# System setup.
hostnamectl set-hostname ${hostname}


# GitLab runner setup.
cd /usr/local/lib/
cp config.toml /etc/gitlab-runner/config.toml && chmod 600 ${_}
gitlab-runner fleeting install
systemctl enable --now ./gitlab-runner.service



echo 'Finished Instance Configuration Script.'