# Dotfiles

Inspired by [Jessie Frazelle dofiles](https://github.com/jfrazelle/dotfiles),
this repo contains some config files for my laptop.

**Prerequisites**

Some packages are needed in order to have this working, here is a list:

- termite
- zsh
- tmux
- xclip
- xdg-utils
- tig, direnv, neovim
- ttf-droid

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

## Update submodules

To update submodules of this project run:

```console
$ git submodule update --rebase --remote
```

## Usage

This repo contains several different config, here is how they live together.

 - **master**: base configuration for my default user and environment. Also
 contains some dedicated config files for my laptop.
 - **home_debian**: anonymous user compliant config, with bigger fonts and
 dedicated config files for my home server. This branch rebase on `master`. No
 development should be done here, only changes for this environment.
 - **demo**: anonymous user compliant config for giving demos. Contains colors
 and config for giving demos. This branch rebase on `home_debian` to get anonymous
 config.
