#!/bin/bash
#
# Setting up a bridge using brctl
#
sudo brctl addbr br0
sudo brctl addif br0 eno1
sudo ip link set dev br0 up
sudo ip addr add 10.0.3.100/24 dev br0
sudo ip link set dev eno1 up
