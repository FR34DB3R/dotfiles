#!/bin/sh
mkdir -p "$HOME/Pictures/screenshots/"
filepath="$HOME/Pictures/screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png"
grim $filepath
ret=$(notify-send "Screenshot" "Saved it!\n$filepath" -a "Screenshot" --action="open=Open File" --wait)

if [ "$ret" = "open" ]; then
        xdg-open $filepath
fi
