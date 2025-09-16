#!/usr/bin/env bash
BRIGHTNESS=$(brightnessctl g)
MAX=$(brightnessctl m)
PERCENT=$(( BRIGHTNESS * 100 / MAX ))
ICON="󰃠"
echo "{\"text\": \"$ICON $PERCENT%\", \"tooltip\": \"Brilho: $PERCENT%\"}"
