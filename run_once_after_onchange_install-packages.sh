#!/bin/bash

############                     Bluetooth setup                     ############

! systemctl --quiet is-enabled bluetooth &&
	systemctl --now enable bluetooth

############                     Yubikey setup                     ############

! systemctl --quiet is-enabled pcscd.socket &&
	systemctl --now enable pcscd.socket

! systemctl --quiet --user is-enabled yubikey-agent
	systemctl --now --user enable yubikey-agent

! systemctl --quiet --user is-enabled ssh-agent
	systemctl --now --user enable ssh-agent

# also you may need to check some commands to get the PIN to work, namely:
# pinentry-gtk-2

############                     Docker setup                      ############

! test -f /etc/systemd/system/multi-user.target.wants/docker.service &&
	systemctl --now enable docker

# add user to docker group
id -nG "$USER" | grep -vqw "docker" && sudo gpasswd -a "${USER}" docker


exit 0
