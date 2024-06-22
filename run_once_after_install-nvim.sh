#!/bin/bash

mkdir -p ~/.config/nvim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim
nvim +PluginInstall +qall
