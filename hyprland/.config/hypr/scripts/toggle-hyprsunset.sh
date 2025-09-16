#!/bin/bash

# Checa se o hyprsunset está rodando
if pgrep -x "hyprsunset" > /dev/null; then
    # Se estiver rodando, mata o processo
    pkill -x "hyprsunset"
    notify-send "HyprSunset" "Deactivated"
else
    # Se não estiver rodando, inicia com a config
    hyprsunset --config ~/.config/hypr/hyprsunset.conf &
    notify-send "HyprSunset" "Activated"
fi
