#!/bin/bash
#
# Set CPU governor to powersave
if [ -e /usr/bin/cpupower ]; then
	sudo cpupower frequency-set --governor performance
    sudo tuned-adm profile latency-performance
else
    echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    sudo tuned-adm profile latency-performance
fi
# EOF