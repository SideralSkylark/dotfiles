#!/usr/bin/env bash

STATE=$(nmcli -t -f WIFI g | cut -d: -f2)

if [ "$STATE" = "enabled" ]; then
    nmcli radio wifi off
    notify-send "WiFi" "WiFi disabled" -i network-wireless-off
else
    nmcli radio wifi on
    notify-send "WiFi" "WiFi enabled" -i network-wireless
fi
