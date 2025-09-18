#!/usr/bin/env bash

get_current_profile() {
  if command -v powerprofilesctl &>/dev/null; then
    powerprofilesctl get || echo "balanced"
  else
    echo "balanced"
  fi
}

set_profile() {
  if command -v powerprofilesctl &>/dev/null; then
    powerprofilesctl set "$1" 2>/dev/null || true
  fi
}

toggle_profile() {
  case "$(get_current_profile)" in
    power-saver) set_profile balanced ;;
    balanced)    set_profile performance ;;
    performance) set_profile power-saver ;;
    *)           set_profile balanced ;;
  esac
}

icon_for() {
  case "$1" in
    power-saver)  printf "󰾆" ;;
    balanced)     printf "󰾅" ;;
    performance)  printf "󰓅" ;;
    *)            printf "󰾅" ;;
  esac
}

tooltip_for() {
  case "$1" in
    power-saver)  printf "Power Profile: Battery Saver\nOptimized for battery life" ;;
    balanced)     printf "Power Profile: Balanced\nPerformance and efficiency" ;;
    performance)  printf "Power Profile: Performance\nMaximum performance mode" ;;
    *)            printf "Power Profile: Balanced\nPerformance and efficiency" ;;
  esac
}

escape_json() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\n'/\\n}"
  printf '%s' "$s"
}

case "${1:-}" in
  toggle)
    toggle_profile
    ;;
  tooltip)
    tooltip_for "$(get_current_profile)"
    ;;
  display)
    icon_for "$(get_current_profile)"
    ;;
  ""|json|*)
    cur=$(get_current_profile)
    text=$(icon_for "$cur")
    tooltip=$(tooltip_for "$cur")
    et=$(escape_json "$text")
    etool=$(escape_json "$tooltip")
    printf '{"text":"%s","tooltip":"%s"}\n' "$et" "$etool"
    ;;
esac
