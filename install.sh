#!/bin/sh
cd "$(CDPATH="" cd -- "$(dirname -- "$0")" && pwd)" || exit 1

program=${0##*/}
program_version=0.1.0

print() { [ -n "$quiet" ] && return 0 || printf "${1} %s\n" "$2" >&2; }
msg() { print "$GREEN>>>${NORMAL}" "$1"; }
warning() { print "${YELLOW}>>> WARNING:${NORMAL}" "$1"; }
warning2() { print "	${YELLOW}>>> ${NORMAL}" "$1"; }
error() { print "${RED}>>> ERROR:${NORMAL}" "$1"; }
die() { error "$1"; exit 1; }


quiet=
config=
home=
data=
etc=

NORMAL="\033[1;0m"
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"

usage() {
	cat >&2 <<-__EOF__
		${program} ${program_version} - install config files
		Usage: ${program} [-qh] [-p PORT]
		Options:
		  --only-home    Install only the home directory files
		  --only-config  Install only the config directory files
		  --only-data    Install only the data directory files
		  --only-etc     Install only the etc directory files

		  -q, --quiet    Disable the messages
		  -h, --help     Show this help
	__EOF__
}

home() {
	msg "installing home"
	for file in $(find "$(pwd)/home" -maxdepth 1 ! -path "$(pwd)/home" ! -name ".*.swp")
	do
		f="$(basename $file)"
		ln -sfn "${file}" "${HOME}/.${f}"
	done
}

config() {
	msg "installing config"
	mkdir -p "${XDG_CONFIG_HOME}"
	for file in $(
		find "$(pwd)/config" -maxdepth 1 ! -path "$(pwd)/config" \
			! -name ".*.swp"
	)
	do
		f="$(basename $file)"
		ln -sfn "${file}" "${XDG_CONFIG_HOME}/${f}"
	done
}

data() {
	msg "installing data"
	base="$(readlink -f "${XDG_DATA_HOME}/..")"

	mkdir -p "${base}/share"
	mkdir -p "${base}/bin"

	for file in $(find "$(pwd)/local" -maxdepth 2 -mindepth 2 ! -name ".*.swp")
	do
		ln -sfn "${file}" "${base}/${file#*$(pwd)/local}"
	done
}

etc() {
	msg "installing etc"
	for file in $(find $(pwd)/etc -type f -not -name ".*.swp")
	do
		sudo mkdir -p "$(dirname "${file#*$(pwd)}")"
		sudo ln -f "$file" "${file#*$(pwd)}"
	done
	systemctl --user daemon-reload
	sudo systemctl daemon-reload
}

if ! args=$(getopt -o qh --long quiet,help,only-config,only-home,only-data,only-etc -n "$program" -- "$@"); then
	usage
	exit 2
fi

eval set -- "$args"
while true; do
	case $1 in
		--only-home) home=1; home;;
		--only-config) config=1; config;;
		--only-data) data=1; data;;
		--only-etc) etc=1; etc;;

		-q|--quiet) quiet=1;; # suppresses msg
		-h|--help)  usage; exit;;
		--)         shift; break;;
		*)          exit 1;; # getopt error
	esac
	shift
done

test -n "$config" -o -n "$home" -o -n "$data" -o -n "$etc" && exit 0
home
config
data
etc
