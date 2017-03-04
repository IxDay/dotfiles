# Dotfiles

Inspired by [Jessie Frazelle dofiles](https://github.com/jfrazelle/dotfiles),
this repo contains some config files for my laptop.

**Prerequisites**

Some packages are needed in order to have this working, here is a list:

- rxvt-unicode-256color
- zsh
- tmux
- xclip
- xdg-open

**To install:**

```console
$ git clone --recursive https://github.com/IxDay/dotfiles
$ make
```

This will create symlinks from this repo to your home folder.


## Development

You can download git submodules recursively with the following command:

```console
$ git submodule update --init --recursive
```
