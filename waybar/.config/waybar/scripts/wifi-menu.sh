#!/usr/bin/env bash
# ======================================================
# WiFi Menu Simplificado para Wofi - Hyprland Friendly
# - Conectar redes já salvas rapidamente
# - Desconectar da rede atual
# - Refresh de redes
# - Abrir nmtui para novas conexões WiFi
# ======================================================

# Detecta interface WiFi e SSID atual
WIFI_IFACE=$(nmcli device status | awk '$2=="wifi" {print $1; exit}')
CURRENT_SSID=$(nmcli -t -f ACTIVE,SSID dev wifi | awk -F: '$1=="yes" {print $2}')
SAVED_CONNECTIONS=$(nmcli -g NAME connection)

# Funções para ícones
get_signal_icon() {
    local s=$1
    if [ "$s" -ge 80 ]; then echo "󰤨"
    elif [ "$s" -ge 60 ]; then echo "󰤥"
    elif [ "$s" -ge 40 ]; then echo "󰤢"
    elif [ "$s" -ge 20 ]; then echo "󰤟"
    else echo "󰤯"
    fi
}

get_security_icon() {
    local sec=$1
    if [[ "$sec" != "--" && -n "$sec" ]]; then echo ""; else echo ""; fi
}

# Arquivo temporário para mapear SSIDs
TEMP_MAP=$(mktemp)
trap "rm -f '$TEMP_MAP'" EXIT

# Monta lista de redes disponíveis que já têm conexão criada
SSID_LIST="󰑐 Refresh Networks"
[ -n "$CURRENT_SSID" ] && SSID_LIST+="\n󰖂 Disconnect from $CURRENT_SSID"

while IFS=: read -r ssid signal security; do
    [ -z "$ssid" ] && continue
    # Só mostra se houver uma conexão salva com este SSID
    if echo "$SAVED_CONNECTIONS" | grep -Fxq "$ssid"; then
        icon=$(get_signal_icon "$signal")
        lock=$(get_security_icon "$security")
        if [ "$ssid" = "$CURRENT_SSID" ]; then
            choice_text="> $icon $lock $ssid (Connected)"
        else
            choice_text="  $icon $lock $ssid"
        fi
        SSID_LIST+="\n$choice_text"
        echo "$choice_text|$ssid|$security" >> "$TEMP_MAP"
    fi
done < <(nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list | sort -u)

# Opção para abrir nmtui
SSID_LIST+="\n󰙅 Open WiFi Manager (nmtui)"

# Menu Wofi
CHOICE=$(echo -e "$SSID_LIST" | wofi --dmenu -p "WiFi Networks:" --width 400 --height 300 --lines 10 --cache-file /dev/null --hide-scroll --matching contains)
[ -z "$CHOICE" ] && exit 0

case "$CHOICE" in
    *"Refresh Networks"*) exec "$0" ;;
    *"Disconnect"* )
        nmcli device disconnect "$WIFI_IFACE"
        notify-send "WiFi" "Disconnected from $CURRENT_SSID" -i network-wireless-offline -t 3000
        exit 0
        ;;
    *"Open WiFi Manager (nmtui)"* )
        # Força refresh antes de abrir nmtui
        nmcli device wifi rescan
        kitty -e nmtui &
        exit 0
        ;;
    * )
        LINE=$(grep -F "$CHOICE|" "$TEMP_MAP")
        SELECTED_SSID=$(echo "$LINE" | cut -d'|' -f2)
        [ -z "$SELECTED_SSID" ] && { notify-send "WiFi" "Error: Could not determine SSID" -i network-wireless-error -t 5000; exit 1; }
        [ "$SELECTED_SSID" = "$CURRENT_SSID" ] && { notify-send "WiFi" "Already connected to $SELECTED_SSID" -i network-wireless -t 3000; exit 0; }

        # Conecta à rede já salva
        nmcli connection up "$SELECTED_SSID" && notify-send "WiFi" "Connected to $SELECTED_SSID" -i network-wireless -t 3000 \
            || notify-send "WiFi" "Failed to connect to $SELECTED_SSID" -i network-wireless-error -t 5000
        ;;
esac
