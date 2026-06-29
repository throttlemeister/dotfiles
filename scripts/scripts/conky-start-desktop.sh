#!/bin/bash
#
# Start all conky instances
#
# 1. SysInfo conky
/usr/bin/conky --daemonize --pause=1 -c ~/.config/conky/conky.conf
# 2. Time/Date conky
/usr/bin/conky --daemonize --pause=1 -c ~/.config/conky/Gotham/conkyrc
