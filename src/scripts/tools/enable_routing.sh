#!/bin/bash
#takes list of interfaces

sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv4.conf.all.rp_filter=0


for if in "$@"
do
    sudo sysctl -w net.ipv4.conf.$if.rp_filter=0
done

