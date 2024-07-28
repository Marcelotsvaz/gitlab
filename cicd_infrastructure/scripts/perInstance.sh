#! /usr/bin/env bash

set -o errexit
echo 'Starting Instance Configuration Script...'



# System setup.
hostnamectl set-hostname ${hostname}


# GitLab runner setup.
cp /usr/local/lib/config.toml /etc/gitlab-runner/config.toml
chmod 600 ${_}

systemctl enable --now docker gitlab-runner



echo 'Finished Instance Configuration Script.'