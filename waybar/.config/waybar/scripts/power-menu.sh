#!/usr/bin/env bash

# Menu options with icons and colors (using ANSI for Wofi)
OPTIONS="\
󰐥 shutdown\n\
󰑤 reboot\n\
󰒲 suspend\n\
󰍃 logout"

# Show the menu with wofi
CHOICE=$(echo -e "$OPTIONS" | wofi --dmenu --prompt "Power" --line-height 30 --font "JetBrainsMono Nerd Font 14" | tr '[:upper:]' '[:lower:]')

# Execute the corresponding action
case "$CHOICE" in
    *shutdown) systemctl poweroff ;;
    *reboot) systemctl reboot ;;
    *suspend) systemctl suspend ;;
    *logout) hyprctl dispatch exit ;;
esac
