#!/bin/bash
#
# Set CPU governor to performance
if [ -e /usr/bin/cpupower ]; then
	sudo cpupower frequency-set --governor performance
else
    echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
fi
# EOF