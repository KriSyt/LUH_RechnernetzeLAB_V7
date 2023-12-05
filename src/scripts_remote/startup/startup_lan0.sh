#!/bin/bash
# https://help.ubuntu.com/community/NetworkConnectionBridge

sleep 4
ip addr flush dev if0
ip addr flush dev if1
ip addr flush dev if2
brctl addbr lan0
brctl addif lan0 if0 if1 if2
ip link set dev lan0 up

/usr/sbin/sshd -D
