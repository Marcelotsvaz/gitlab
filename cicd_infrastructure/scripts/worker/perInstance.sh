#! /usr/bin/env bash

set -o errexit
echo 'Starting Instance Configuration Script...'



# System setup.
hostnamectl set-hostname ${hostname}


# Configure EC2 Instance Connect.
cd /usr/local/lib/
curl --location --silent https://github.com/aws/aws-ec2-instance-connect-config/archive/551c73e8ec1f5ade4c8b1f52cf616e75b47879b4.tar.gz | tar -xz
cp aws-ec2-instance-connect-config-*/src/bin/* .
rm -r aws-ec2-instance-connect-config-*

useradd --system --shell /usr/bin/nologin instance-connect

cat > /etc/ssh/sshd_config.d/10-instance-connect.conf << 'EOF'
	AuthorizedKeysCommand /usr/local/lib/eic_run_authorized_keys %u %f
	AuthorizedKeysCommandUser instance-connect
EOF

sed -Ei 's/^PubkeyAcceptedKeyTypes ssh-ed25519$/PubkeyAcceptedAlgorithms ssh-ed25519,ssh-rsa/' /etc/ssh/sshd_config
systemctl reload sshd


# Worker setup.
useradd --system --groups docker --create-home ${worker_user}
systemctl enable --now docker



echo 'Finished Instance Configuration Script.'