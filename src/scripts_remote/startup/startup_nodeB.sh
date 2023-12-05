#!/bin/bash
sleep 4

ifconfig if0 192.168.2.1 netmask 255.255.255.0

/usr/sbin/sshd -D
