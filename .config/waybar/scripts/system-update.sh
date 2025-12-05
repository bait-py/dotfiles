#!/usr/bin/env bash
#
# Check for APT package updates and upgrade them. When run with the
# 'module' argument, output the status icon and update counts in JSON format for
# Waybar
#
# Requirements:
# 	- apt (installed by default on Ubuntu)
# 	- notify-send (libnotify-bin)
#
# Author: Jesse Mirabel <sejjymvm@gmail.com>
# Modified for Ubuntu: December 2025
# License: MIT

GRN='\033[1;32m'
BLU='\033[1;34m'
RST='\033[0m'

TIMEOUT=10

check-updates() {
	is_online=true
	repo=0
	security=0

	# Check if apt lists are recent (less than 1 hour old)
	# to avoid requiring sudo for every check
	local apt_lists="/var/lib/apt/lists"
	local last_update=0
	
	if [[ -d "$apt_lists" ]]; then
		last_update=$(stat -c %Y "$apt_lists" 2>/dev/null || echo 0)
	fi
	
	local current_time
	current_time=$(date +%s)
	local time_diff=$((current_time - last_update))
	
	# Only update if lists are older than 1 hour (3600 seconds)
	if ((time_diff > 3600)); then
		# Try to update silently, ignore if it fails (no sudo password)
		sudo -n apt-get update > /dev/null 2>&1 || true
	fi

	# Check for upgradable packages (doesn't require sudo)
	local rout
	rout=$(apt list --upgradable 2>/dev/null | grep -v "^Listing")
	repo=$(grep -cve '^\s*$' <<< "$rout")

	# Check for security updates
	if ((repo > 0)); then
		local sout
		sout=$(apt list --upgradable 2>/dev/null | grep -i security)
		security=$(grep -cve '^\s*$' <<< "$sout")
	fi
}

update-packages() {
	printf '\n%bUpdating package lists...%b\n' "$BLU" "$RST"
	sudo apt-get update

	printf '\n%bUpgrading packages...%b\n' "$BLU" "$RST"
	sudo apt-get upgrade -y

	printf '\n%bCleaning up...%b\n' "$BLU" "$RST"
	sudo apt-get autoremove -y
	sudo apt-get autoclean

	notify-send 'Update Complete' -i 'package-install'
	printf '\n%bUpdate Complete!%b\n' "$GRN" "$RST"
	read -rs -n 1 -p 'Press any key to exit...'
}

display-module() {
	if [[ $is_online == false ]]; then
		echo "{ \"text\": \"󰒑\", \"tooltip\": \"Cannot fetch updates. Right-click to retry.\" }"
		return 0
	fi

	local tooltip="<b>Updates</b>: $repo"
	if ((security > 0)); then
		tooltip+="\n<b>Security</b>: $security"
	fi

	if ((repo == 0)); then
		echo "{ \"text\": \"󰸟\", \"tooltip\": \"No updates available\" }"
	else
		echo "{ \"text\": \"󰄠\", \"tooltip\": \"$tooltip\" }"
	fi
}

main() {
	case $1 in
		'module')
			check-updates
			display-module
			;;
		*)
			printf '%bChecking for updates...%b' "$BLU" "$RST"
			check-updates
			update-packages
			# use signal to update the module
			pkill -RTMIN+1 waybar
			;;
	esac
}

main "$@"
