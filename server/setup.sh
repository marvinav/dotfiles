#!/bin/sh
REPODIR="$(cd "$(dirname "$0")"; pwd -P)"

# Enable UFW
ufw allow ssh
ufw allow http
ufw allow https
ufw enable

# Setup ssh
groupadd ssh-team-list
usermod -aG ssh-team-list $SUDO_USER
cat $REPODIR/ssh-team-list.conf | tee -a /etc/ssh/sshd_config
systemctl restart sshd

apt install fail2ban
cp $REPODIR/jail.local /etc/fail2ban
systemctl enable fail2ban
