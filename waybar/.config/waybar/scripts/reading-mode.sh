#!/usr/bin/env bash

TEMP=4000

# Verifica se está ativo
is_active() {
    if pgrep -x hyprsunset >/dev/null; then
        echo "on"
    else
        echo "off"
    fi
}

# Alterna o modo leitura
toggle() {
    if [ "$(is_active)" = "on" ]; then
        pkill -x hyprsunset
    else
        hyprsunset -t "$TEMP" &
    fi
    sleep 0.2  # Pequeno delay para o processo iniciar/terminar
}

# Ícone para Waybar
icon() {
    if [ "$(is_active)" = "on" ]; then
        printf "󰃞"  # ligado
    else
        printf "󰃟"  # desligado
    fi
}

# Tooltip para Waybar
tooltip() {
    if [ "$(is_active)" = "on" ]; then
        printf "Reading Mode: ON\nClick to turn OFF"
    else
        printf "Reading Mode: OFF\nClick to turn ON"
    fi
}

case "$1" in
    toggle) toggle ;;
    tooltip) tooltip ;;
    display|"") icon ;;
esac
