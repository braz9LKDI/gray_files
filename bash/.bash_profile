#!/bin/bash
#  ______  ______   ______   ______  __   __       ______
# /\  == \/\  == \ /\  __ \ /\  ___\/\ \ /\ \     /\  ___\
# \ \  _-/\ \  __< \ \ \/\ \\ \  __\\ \ \\ \ \____\ \  __\
#  \ \_\   \ \_\ \_\\ \_____\\ \_\   \ \_\\ \_____\\ \_____\
#   \/_/    \/_/ /_/ \/_____/ \/_/    \/_/ \/_____/ \/_____/

if [[ -f "$HOME/.bashrc" ]]; then
	source "$HOME/.bashrc"
fi

if [[ -f "/usr/share/blesh/ble.sh" ]]; then
	source "/usr/share/blesh/ble.sh"
fi

if [[ -f "/usr/share/nvm/init-nvm.sh" ]]; then
	source "/usr/share/nvm/init-nvm.sh"
fi

if [[ -d "$HOME/.spicetify" ]]; then
	export PATH="$HOME/.spicetify:$PATH"
fi

if [[ -d "$HOME/.local/bin" ]]; then
	export PATH="$HOME/.local/bin":"$PATH"
fi

if [[ -d "$HOME/.dotnet/tools" ]]; then
	export PATH="$HOME/.dotnet/tools:$PATH"
fi
