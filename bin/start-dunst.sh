#!/bin/sh

# Terminate already running bar instances
killall -q dunst

# Wait until the processes have been shut down
while pgrep -u $UID -x dunst >/dev/null; do sleep 1; done

# dunst, using default config location ~/.config/dunst/dunstrc
exec dunst
