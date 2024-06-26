set -Ux XDG_CONFIG_HOME "$HOME/.config"
set -Ux XDG_DATA_HOME "$HOME/.local/share"
set -Ux XDG_CACHE_HOME "$HOME/.cache"

set -Ux LANG "en_US.UTF-8"
set -Ux LANGUAGE "en_US"
set -Ux LC_ALL "C"

fish_add_path "$HOME/.local/bin"

set -Ux ASDF_DATA_DIR "$XDG_DATA_HOME/asdf"

###############################################################################
#          Everything related to age encryption and my identity flow          #
#                                                                             #
# Check the README in $XDG_DATA_HOME/password-store/passage/ for instructions #
###############################################################################
alias yk-agent-hang='kill -HUP $(systemctl --user show --property MainPID --value yubikey-agent)'
set -Ux SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/yubikey-agent/yubikey-agent.sock"
set -Ux PASSAGE_AGE "rage"
set -Ux PASSAGE_DIR "$XDG_DATA_HOME/password-store/passage/store"
set -Ux PASSAGE_IDENTITIES_FILE "$XDG_DATA_HOME/password-store/passage/identities"

set -Ux EDITOR nvim
set -Ux PAGER less

set -Ux KUBECONFIG   "$XDG_CONFIG_HOME/kube/config"
set -Ux KUBECACHEDIR "$XDG_CACHE_HOME/kube"

set -Ux GOPATH "$XDG_DATA_HOME/go"

## asdf install
fish_add_path "/opt/asdf-vm/bin"
source "/opt/asdf-vm/asdf.fish"

direnv hook fish | source
zoxide init fish | source

if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias vim="nvim"
alias svim='sudo -E nvim'
alias grep='grep --color=always --exclude-dir={.bzr,CVS,.git,.hg,.svn,node_modules,.terragrunt-cache,.terraform,.next,.direnv}'
alias less='less -SR'
alias tree="tree -C"
alias jqr='/usr/bin/jq -r'

alias passwdgen='export LC_CTYPE=C; cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1'
alias server='python3 -m http.server'
alias rsync='rsync --exclude ".vscode" --exclude ".venv" --exclude ".direnv" --exclude ".git" --delete'
alias tlscert='openssl x509 -in - -text -noout'
alias myip='curl -s https://api.myip.com | jq "."'

alias sshi='ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null'
alias sshp='ssh -o PreferredAuthentications=keyboard-interactive,password -o PubkeyAuthentication=no'
alias scpi='/usr/bin/scp -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null'

set -Ux DOCKER_HOST "unix:///var/run/docker.sock"
alias dockerr='docker run --rm -ti'
alias dockerip='docker inspect -f "{{.NetworkSettings.IPAddress}}"'
alias dockerrm='docker rm $(docker ps -qa)'
alias dockerrmi='docker rmi $(docker images | awk '\''$1 ~ /\<none\>/ {print $3}'\'')'
alias dockerrmv='docker volume rm $(docker volume ls -qf dangling=true)'
alias dockerps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}\t{{.Status}}"'

alias fixtmux='tmux set-option status on'
alias tmux='tmux -u'

alias mcli='mcli --config-dir=$XDG_CONFIG_HOME/minio'

function k --wraps kubectl
	kubectl $argv
	return $status
end

function kx --wraps kubectx
	KUBECTX_IGNORE_FZF=1 kubectx $argv
	return $status
end

function kdebug
	kubectl run --stdin --tty --rm debug --image=alpine:3.13 --restart Never
	return $status
end

function tmpdir
	set params -d
	count $argv > /dev/null && set -a params -p ~/Documents/Dev/misc/tmp -t "$argv[1]".XXX

	test -t 1 && cd $(mktemp $params) && return
	mktemp $params | tee /dev/stderr
end

# https://stackoverflow.com/questions/46698467/is-it-possible-to-wrap-an-existing-function-with-another-function-using-the-same#answer-46699511
#functions -c cd _cd
function cd --wraps z
	! count $argv > /dev/null && test -n "$PROJECT" && set argv "$PROJECT"

	z $argv
	return $status
end

function asdf_plugin_install
	set plugins "$(asdf plugin list)"
	while read tool _
		grep -q "^$tool" $(echo "$plugins" | psub) || asdf plugin-add "$tool"
	end < .tool-versions
end

function kns
	count $argv > /dev/null \
		&& kubectl config set-context --current --namespace "$argv[1]" \
		|| kubectl get ns
end

function tferror
	echo "$argv[1]" | base64 -d | gunzip
end

