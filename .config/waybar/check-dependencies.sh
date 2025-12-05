#!/usr/bin/env bash
#
# Check and install dependencies for Waybar configuration on Ubuntu
#
# Author: Adapted for Ubuntu
# Created: December 2025
# License: MIT

GRN='\033[1;32m'
RED='\033[1;31m'
YLW='\033[1;33m'
BLU='\033[1;34m'
RST='\033[0m'

REQUIRED=(
	'brightnessctl:brightnessctl:Control screen brightness'
	'bluetoothctl:bluez:Bluetooth management'
	'nmcli:network-manager:WiFi and network management'
	'pactl:pulseaudio-utils:Audio control (PulseAudio)'
	'fzf:fzf:Interactive fuzzy finder for menus'
	'notify-send:libnotify-bin:Desktop notifications'
)

OPTIONAL=(
	'pipewire:pipewire:Modern audio server (alternative to PulseAudio)'
	'wireplumber:wireplumber:PipeWire session manager'
	'kitty:kitty:Terminal emulator (used in config)'
)

check_command() {
	local cmd=$1
	local pkg=$2
	local desc=$3
	
	if command -v "$cmd" > /dev/null 2>&1; then
		printf '%b✓%b %-20s %b(installed)%b\n' "$GRN" "$RST" "$cmd" "$GRN" "$RST"
		return 0
	else
		printf '%b✗%b %-20s %b(missing - install: sudo apt install %s)%b\n' "$RED" "$RST" "$cmd" "$RED" "$pkg" "$RST"
		return 1
	fi
}

main() {
	echo -e "${BLU}=== Waybar Dependencies Check for Ubuntu ===${RST}\n"
	
	echo -e "${YLW}Required Dependencies:${RST}"
	local missing_required=0
	local install_list=()
	
	for dep in "${REQUIRED[@]}"; do
		IFS=':' read -r cmd pkg desc <<< "$dep"
		if ! check_command "$cmd" "$pkg" "$desc"; then
			((missing_required++))
			install_list+=("$pkg")
		fi
	done
	
	echo -e "\n${YLW}Optional Dependencies:${RST}"
	local missing_optional=0
	
	for dep in "${OPTIONAL[@]}"; do
		IFS=':' read -r cmd pkg desc <<< "$dep"
		if ! check_command "$cmd" "$pkg" "$desc"; then
			((missing_optional++))
		fi
	done
	
	echo -e "\n${BLU}=== Summary ===${RST}"
	
	if ((missing_required == 0)); then
		echo -e "${GRN}All required dependencies are installed!${RST}"
	else
		echo -e "${RED}Missing ${missing_required} required dependencies.${RST}"
		echo -e "\n${YLW}To install all missing required packages, run:${RST}"
		echo -e "${BLU}sudo apt install ${install_list[*]}${RST}"
	fi
	
	if ((missing_optional > 0)); then
		echo -e "\n${YLW}Note: ${missing_optional} optional dependencies are missing.${RST}"
	fi
	
	echo -e "\n${BLU}=== Additional Notes ===${RST}"
	echo -e "• If you're using PipeWire instead of PulseAudio, install: ${BLU}pipewire wireplumber pipewire-pulse${RST}"
	echo -e "• The config uses 'kitty' terminal by default. Change in modules if you use a different terminal."
	echo -e "• For Hyprland session management, ensure you have loginctl working properly."
	
	# Check Hyprland
	echo -e "\n${YLW}Hyprland Check:${RST}"
	if command -v hyprctl > /dev/null 2>&1; then
		printf '%b✓%b Hyprland is installed\n' "$GRN" "$RST"
		hyprctl version | head -n 1
	else
		printf '%b✗%b Hyprland not found\n' "$RED" "$RST"
	fi
}

main "$@"
