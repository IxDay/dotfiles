#!/bin/bash

cp -r /etc/apt/sources.list.d ./
cp -r /etc/apt/preferences.d ./
cp -r ~/.i3/* i3/
cp ~/.config/systemd/user/ssh-agent.service ./
cp ~/.oh-my-zsh/themes/max.zsh-theme max.zsh-theme
cp ~/.Xresources Xresources
cp ~/.gtkrc-2.0 gtkrc-2.0
cp ~/.config/gtk-3.0/settings.ini ./
cp ~/.xinitrc xinitrc
cp ~/.zprofile zprofile
cp ~/.zshrc zshrc
cp ~/.aliases aliases
cp ~/.vimrc vimrc
cp ~/.i3status.conf i3status.conf
cp ~/.local/share/mc/skins/personal.ini personal.ini
cp ~/.cmus/personal.theme personal.theme
cp ~/.config/dunst/dunstrc dunstrc
cp ~/.gitconfig gitconfig
cp ~/.gitignore_global gitignore_global
cp ~/.editorconfig editorconfig
