#!/bin/bash
ROUTERC_IF="if2"

SSHP_ARGS="-p password"
SSH_ARGS="-o StrictHostKeyChecking=no -o ConnectTimeout=5 -o ConnectionAttempts=3"

LOGFILE="/output/05_change_route.log"
TEMPDIR="/output/tmp"

> $LOGFILE


#### Remove old route and add new
sshpass $SSHP_ARGS ssh root@routerA "sudo route del -net 192.168.2.0/24 gw 192.168.10.2 > /tmp/change_route_routerA_del1.log"
sshpass $SSHP_ARGS ssh root@routerA "sudo route add -net 192.168.2.0/24 gw 192.168.20.2 > /tmp/change_route_routerA_add1.log"
sshpass $SSHP_ARGS ssh root@routerA "sudo ip route flush cache > /tmp/change_route_routerA_flush1.log"

sleep 1

echo "Ping NodeA -> NodeB   and  dump on routerC:if3"

#### Ping and dump
sshpass $SSHP_ARGS ssh -f root@routerC "tcpdump -U -i $ROUTERC_IF > /tmp/change_route_routerC_dump.log &"
sshpass $SSHP_ARGS ssh root@nodeA "ping 192.168.2.1 -q -c4 > /tmp/change_route_nodeA_ping.log"
sshpass $SSHP_ARGS ssh root@routerC "pkill tcpdump"

#### change to old route
sshpass $SSHP_ARGS ssh root@routerA "sudo route del -net 192.168.2.0/24 gw 192.168.20.2 > /tmp/change_route_routerA_del2.log"
sshpass $SSHP_ARGS ssh root@routerA "sudo route add -net 192.168.2.0/24 gw 192.168.10.2 > /tmp/change_route_routerA_add2.log"
sshpass $SSHP_ARGS ssh root@routerA "sudo ip route flush cache > /tmp/change_route_routerA_flush2.log"



echo "Download logs"

#### RouterA
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerA:/tmp/change_route_routerA_del1.log $TMPDIR/change_route_routerA_del1.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerA:/tmp/change_route_routerA_add1.log $TMPDIR/change_route_routerA_add1.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerA:/tmp/change_route_routerA_flush1.log $TMPDIR/change_route_routerA_flush1.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerA:/tmp/change_route_routerA_del2.log $TMPDIR/change_route_routerA_del2.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerA:/tmp/change_route_routerA_add2.log $TMPDIR/change_route_routerA_add2.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerA:/tmp/change_route_routerA_flush2.log $TMPDIR/change_route_routerA_flush2.log
#### NodeA
sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeA:/tmp/change_route_nodeA_ping.log $TMPDIR/change_route_nodeA_ping.log
#### RouterC
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerC:/tmp/change_route_routerC_dump.log $TMPDIR/change_route_routerC_dump.log

echo "RouterA change Routes:" >> $LOGFILE
cat $TMPDIR/change_route_routerA_del1.log >> $LOGFILE
cat $TMPDIR/change_route_routerA_add1.log >> $LOGFILE
cat $TMPDIR/change_route_routerA_flush1.log >> $LOGFILE

echo -e "\n\nNodeA->NodeB(192.168.2.1)" >> $LOGFILE
cat $TMPDIR/change_route_nodeA_ping.log >> $LOGFILE

echo -e "\n\nTCP-Dump RouterC IF3" >> $LOGFILE

echo -e "\n\nReconfigure old Routes" >> $LOGFILE
cat $TMPDIR/change_route_routerA_del2.log >> $LOGFILE
cat $TMPDIR/change_route_routerA_add2.log >> $LOGFILE
cat $TMPDIR/change_route_routerA_flush2.log >> $LOGFILE



