#!/bin/sh

hyprctl dispatch exit
loginctl kill-user $(whoami)
killall Hyprland
systemctl restart sddm
