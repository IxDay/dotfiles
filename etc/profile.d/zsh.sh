#!/bin/sh

if [ -n "$XDG_CONFIG_HOME" ] && [ -d "$XDG_CONFIG_HOME/zsh" ]; then
	export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi
