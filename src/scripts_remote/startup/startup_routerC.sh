#!/bin/bash
sleep 4

ifconfig if1 192.168.20.2 netmask 255.255.255.0
ifconfig if2 192.168.30.2 netmask 255.255.255.0
ifconfig if3 192.168.2.251 netmask 255.255.255.0



/usr/sbin/sshd -D
