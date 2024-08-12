#! /usr/bin/env bash

set -o errexit
echo 'Starting Instance Configuration Script...'



# System setup.
hostnamectl set-hostname ${hostname}


# Worker setup.
useradd --system --groups docker --create-home ${worker_user}
systemctl enable --now docker

aws autoscaling complete-lifecycle-action \
	--auto-scaling-group-name ${auto_scaling_group_name} \
	--instance-id $(curl --silent http://169.254.169.254/latest/meta-data/instance-id) \
	--lifecycle-hook-name worker_ready \
	--lifecycle-action-result CONTINUE



echo 'Finished Instance Configuration Script.'