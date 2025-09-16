#!/bin/bash

# Configurações do wlsunset
CONFIG="-l 6500 -d 4000 -t 6:30 -T 19:30 -m 0.8 -b 0.8"

# Verifica se o wlsunset está em execução
if pgrep -x "wlsunset" > /dev/null; then
    # Se estiver rodando, mata o processo
    pkill wlsunset
    notify-send -a "wlsunset" "❌ Night Light" "Turned-Off" -t 2000
else
    # Se não estiver rodando, inicia o processo
    wlsunset $CONFIG &
    notify-send -a "wlsunset" "🌙 Night Light" "Turned-On" -t 2000
fi
