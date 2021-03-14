#!/bin/sh
# Starts given process if it does not exist and kills
# it if it does.

if pgrep $1 > /dev/null; then
  killall -q $1
  while pgrep -u $UID -x $1 >/dev/null; do sleep 1; done
fi
  exec $@
exit
