set -Ux XDG_CONFIG_HOME "$HOME/.config"
set -Ux XDG_DATA_HOME "$HOME/.local/share"
set -Ux GOPATH "$HOME/.local/share/go"
set -Ux COLIMA_HOME "$HOME/.config/colima"
set -Ux DOCKER_CONFIG "$HOME/.config/docker"

set -Ux BAT_THEME "ansi"

alias tlscert='openssl x509 -text -noout'
alias activate='xattr -d com.apple.quarantine'

function server
    ! count $argv > /dev/null && set argv "9000"
    python3 -m http.server $argv[1]
end

# then run `verify /full/path/to/binary`
alias verify='xattr -d com.apple.quarantine'

# https://stackoverflow.com/questions/26198926/why-does-lesshst-keep-showing-up-in-my
set -Ux LESSHISTFILE -

set -U fish_greeting ""

fish_add_path "$HOME/.local/bin"

mise activate | source
zoxide init fish | source

set fzf_fd_opts --hidden --no-ignore --exclude '.git' --exclude 'node_modules' --exclude '.cache' --exclude 'Library' --exclude 'Applications'
fzf_configure_bindings --directory=\cf

function cd --wraps z
    ! count $argv > /dev/null && test -n "$PROJECT" && set argv "$PROJECT"
    z $argv
    return $status
end

# https://stackoverflow.com/questions/31396985/why-is-mktemp-on-os-x-broken-with-a-command-that-worked-on-linux
function tmpdir
	set params -d
	count $argv > /dev/null && set -a params -d "$HOME/Documents/Dev/misc/tmp/$argv[1].XXX"

	test -t 1 && cd $(mktemp $params) && return
	mktemp $params | tee /dev/stderr
end


alias k='kubectl'
function kdebug
    ! count $argv > /dev/null && set argv "alpine:3.20"
	kubectl run --stdin --tty --rm debug --image="$argv[1]" --restart Never
	return $status
end

function kns
	count $argv > /dev/null \
		&& kubectl config set-context --current --namespace "$argv[1]" \
		|| kubectl get ns
end

function kx --wraps kubectx
	KUBECTX_IGNORE_FZF=1 kubectx $argv
	return $status
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

