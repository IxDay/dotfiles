#!/bin/bash

sudo sed -i '/\[multilib]/{s/^#//;n;s/^#//}' /etc/pacman.conf
yay -Syu --noconfirm
