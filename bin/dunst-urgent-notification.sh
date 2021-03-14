#!/bin/sh
# Apps like discord don't deliver these notifications as they should.
# So we have to manually send them.
wmctrl -xr $1 -b add,demands_attention
