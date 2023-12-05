#!/bin/bash
sleep 4
ifconfig if0 192.168.2.250 netmask 255.255.255.0
ifconfig if1 192.168.10.2 netmask 255.255.255.0
ifconfig if2 192.168.30.1 netmask 255.255.255.0


/usr/sbin/sshd -D
