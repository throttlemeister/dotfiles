#!/bin/bash
#
# Set CPU governor to powersave
if [ -e /usr/bin/cpupower ]; then
	sudo cpupower frequency-set --governor powersave
	sudo tuned-adm profile powersave
else
	echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
	sudo tuned-adm profile powersave
fi
# EOF
