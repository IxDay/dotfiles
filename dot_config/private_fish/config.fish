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

set -Ux BAT_THEME "ansi"
set -Ux LS_COLOR "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.7z=01;31:*.ace=01;31:*.alz=01;31:*.apk=01;31:*.arc=01;31:*.arj=01;31:*.bz=01;31:*.bz2=01;31:*.cab=01;31:*.cpio=01;31:*.crate=01;31:*.deb=01;31:*.drpm=01;31:*.dwm=01;31:*.dz=01;31:*.ear=01;31:*.egg=01;31:*.esd=01;31:*.gz=01;31:*.jar=01;31:*.lha=01;31:*.lrz=01;31:*.lz=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.lzo=01;31:*.pyz=01;31:*.rar=01;31:*.rpm=01;31:*.rz=01;31:*.sar=01;31:*.swm=01;31:*.t7z=01;31:*.tar=01;31:*.taz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tgz=01;31:*.tlz=01;31:*.txz=01;31:*.tz=01;31:*.tzo=01;31:*.tzst=01;31:*.udeb=01;31:*.war=01;31:*.whl=01;31:*.wim=01;31:*.xz=01;31:*.z=01;31:*.zip=01;31:*.zoo=01;31:*.zst=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:"

## asdf install
fish_add_path "/opt/asdf-vm/bin"
source "/opt/asdf-vm/asdf.fish"

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

