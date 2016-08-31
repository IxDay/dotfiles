export VISUAL=vim
export EDITOR="$VISUAL"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_PATH="$GEM_HOME"
export GEM_SPEC_CACHE="$GEM_HOME/specs"

export GOPATH=$HOME/documents/dev/go/workspace

# move everything to the $HOME/.config or $HOME/.local folder \o/
export XAUTHORITY="$XDG_RUNTIME_DIR/X11/xauthority"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export VAGRANT_HOME="$XDG_DATA_HOME/vagrant"
export HISTFILE="$XDG_DATA_HOME/zsh/history"
export MPLAYER_HOME="$XDG_CONFIG_HOME/mplayer"
export PGPASSFILE="$XDG_CONFIG_HOME/pgsql/pgpass"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

export PATH="$GEM_PATH/bin:$GOPATH/bin:/usr/lib/go/bin:$PATH"
