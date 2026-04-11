#!/bin/bash
#  ______   ______   ______   __  __       __    __   ______   __   __   ______   ______   ______   ______
# /\  ___\ /\  == \ /\  __ \ /\ \_\ \     /\ "-./  \ /\  __ \ /\ "-.\ \ /\  __ \ /\  ___\ /\  ___\ /\  == \
# \ \ \__ \\ \  __< \ \  __ \\ \____ \    \ \ \-./\ \\ \  __ \\ \ \-.  \\ \  __ \\ \ \__ \\ \  __\ \ \  __<
#  \ \_____\\ \_\ \_\\ \_\ \_\\/\_____\    \ \_\ \ \_\\ \_\ \_\\ \_\\"\_\\ \_\ \_\\ \_____\\ \_____\\ \_\ \_\
#   \/_____/ \/_/ /_/ \/_/\/_/ \/_____/     \/_/  \/_/ \/_/\/_/ \/_/ \/_/ \/_/\/_/ \/_____/ \/_____/ \/_/ /_/

dotfiles_path="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -f "$HOME/.local/bin/colors_and_helpers" ]]; then
	echo "here"
	mkdir -p "$HOME/.local/bin/"
	ln -fs "$dotfiles_path/scripts/colors_and_helpers" "$HOME/.local/bin/"
fi
source "$HOME/.local/bin/colors_and_helpers"

set -euo pipefail

# Description: handle the Ctrl+C signal and exit the program.
# Parameters: none.
function cleanup() {
	# Restore cursor only for interactive runs
	if [[ -t 1 ]]; then
		tput cnorm || true
	fi
}

trap cleanup EXIT

# --------------------------- DEFAULT AND CONSTANTS -------------------------- #

declare -r programs=(
	"hyprland"
	"waybar"
	"firefox"
	"bin"
	"kitty"
	"bash"
	"bash"
	"bash"
	"nvim"
	"mpd"
	"rmpc"
	"swappy"
	"mako"
	"zathura"
	"git"
	"openSSH"
	"vscode"
	"vscode"
)

declare -r target_paths=(
	"hyprland"
	"waybar"
	"firefox"
	"scripts"
	"kitty"
	"bash/.bashrc"
	"bash/.bash_utilities"
	"bash/.bash_profile"
	"nvim"
	"mpd"
	"rmpc"
	"swappy"
	"mako"
	"zathura"
	".gitconfig"
	"ssh_config"
	"vscode/keybindings.json"
	"vscode/settings.json"
)

declare -r link_paths=(
	".config/hypr"
	".config/waybar"
	".mozilla/firefox"
	".local/bin"
	".config/kitty"
	""
	""
	""
	".config/nvim"
	".config/mpd"
	".config/rmpc"
	".config/swappy"
	".config/mako"
	".config/zathura"
	""
	".ssh/config"
	".config/Code"
	".config/Code"
)

# Ensure metadata integrity
if [[ ${#programs[@]} -ne ${#target_paths[@]} || ${#programs[@]} -ne ${#link_paths[@]} ]]; then
	error "array length mismatch\n"
	exit 1
fi

# ------------------------------- USAGE BANNER ------------------------------- #

# Description: builds the final destination path for an index.
# Parameters:
# 	- $1: dotfile index.
function destination_path_for_index() {
	local idx=$1
	if [[ -z ${link_paths[$idx]} ]]; then
		echo "$HOME/$(basename -- "${target_paths[$idx]}")"
	else
		echo "$HOME/${link_paths[$idx]}"
	fi
}

# Description: displays the help panel with usage instructions for the script.
# Parameters: none.
function usage() {
	info "Usage:\n"
	local idx dest
	for idx in "${!programs[@]}"; do
		dest="$(destination_path_for_index "$idx")"
		echo -e "${GREEN}$idx${RESET}) Program: ${programs[idx]} Destination: ${dest}"
	done

	echo -e "$\t${MAGENTA}-i${RESET} index [index ...]"
	echo -e "$\t${MAGENTA}-h${RESET} show this help panel\n"
}

# Description: validates if the given index is a valid index.
# Parameters: none.
function validate_index() {
	local idx=$1
	if [[ ! $idx =~ ^[0-9]+$ ]]; then
		error "${idx} is a invalid index"
		exit 1
	fi

	if (( idx >= ${#programs[@]} )); then
		error "${idx} index is out of range"
		exit 1
	fi
}

# Description: applies dotfiles by creating symbolic links from target paths to link paths.
# Parameters:
# 	- $@: The indices of the dotfiles to apply.
function apply_dotfiles() {
	local idx source dest
	for idx in "$@"; do
		validate_index "$idx"
		source="${dotfiles_path}/${target_paths[$idx]}"
		dest="$(destination_path_for_index "$idx")"
		# Create destination parent directory if it does not exist
		mkdir -p "$(dirname -- "$dest")"
		echo -e "${BLUE}$source${RESET} -> ${BLUE}$dest${RESET}"
		ln -sfnT "$source" "$dest"
	done
}

# ----------------------------- PARSE CLI OPTIONS ---------------------------- #

if [[ $# -eq 0 ]]; then
	usage
	exit 0
fi

while getopts ":hi" opt; do
	case $opt in
		h)
			usage
			exit 0
			;;
		i) ;;
		\?)
			error "$OPTARG is a unknown option"
			usage
			exit 1
			;;
	esac
done
shift $((OPTIND - 1))

# If -i was given, remaining arguments are indices
apply_dotfiles "$@"
