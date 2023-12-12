#!/bin/bash
ROUTERC_IF="if2"

SSHP_ARGS="-p password"
SSH_ARGS="-o StrictHostKeyChecking=no -o ConnectTimeout=5 -o ConnectionAttempts=3"

LOGFILE="/output/04_setup_routes.log"
TEMPDIR="/output/tmp"

> $LOGFILE

### NodeA
sshpass $SSHP_ARGS ssh root@nodeA sudo route add -net 192.168.2.0/24 gw 192.168.1.250
sshpass $SSHP_ARGS ssh root@nodeA sudo route add -net 192.168.30.0/24 gw 192.168.1.250

### NodeB
sshpass $SSHP_ARGS ssh root@nodeB sudo route add -net 192.168.1.0/24 gw 192.168.2.250
sshpass $SSHP_ARGS ssh root@nodeB sudo route add -net 192.168.30.0/24 gw 192.168.2.250

#### RouterA
sshpass $SSHP_ARGS ssh root@routerA sudo route add -net 192.168.2.0/24 gw 192.168.10.2
sshpass $SSHP_ARGS ssh root@routerA sudo route add -net 192.168.30.0/24 gw 192.168.20.2

#### RouterB
sshpass $SSHP_ARGS ssh root@routerB sudo route add -net 192.168.1.0/24 gw 192.168.10.1
sshpass $SSHP_ARGS ssh root@routerB sudo route add -net 192.168.30.0/24 gw 192.168.30.2

#### RouterC
sshpass $SSHP_ARGS ssh root@routerC sudo route add -net 192.168.1.0/24 gw 192.168.20.1
sshpass $SSHP_ARGS ssh root@routerC sudo route add -net 192.168.2.0/24 gw 192.168.30.1

echo "routes set -> Run Traceroute"

##4 ping nodeB->nodeA
sshpass $SSHP_ARGS ssh -f root@routerC "tcpdump -i $ROUTERC_IF > /tmp/setup_routes_routerC_dump.log &"

sshpass $SSHP_ARGS ssh root@nodeA "traceroute 192.168.2.1 > /tmp/setup_routes_nodeA_trace.log"
sshpass $SSHP_ARGS ssh root@nodeB "ping 192.168.1.1 -q -c4 > /tmp/setup_routes_nodeB_ping.log"
sshpass $SSHP_ARGS ssh root@nodeB "traceroute 192.168.1.1 > /tmp/setup_routes_nodeB.log"

sshpass $SSHP_ARGS ssh root@routerC "pkill tcpdump"



### Generate Routing Tables
sshpass $SSHP_ARGS ssh root@nodeA "route | grep 192 > /tmp/setup_routes_table_nodeA.log"
sshpass $SSHP_ARGS ssh root@nodeB "route | grep 192 > /tmp/setup_routes_table_nodeB.log"
sshpass $SSHP_ARGS ssh root@routerA "route | grep 192 > /tmp/setup_routes_table_routerA.log"
sshpass $SSHP_ARGS ssh root@routerB "route | grep 192 > /tmp/setup_routes_table_routerB.log"
sshpass $SSHP_ARGS ssh root@routerC "route | grep 192 > /tmp/setup_routes_table_routerC.log"



echo "download logs"


sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeA:/tmp/setup_routes_nodeA_trace.log $TMPDIR/setup_routes_nodeA_trace.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeB:/tmp/setup_routes_nodeB_ping.log $TMPDIR/setup_routes_nodeB_ping.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeB:/tmp/setup_routes_nodeB.log $TMPDIR/setup_routes_nodeB.log

sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeA:/tmp/setup_routes_table_nodeA.log $TMPDIR/setup_routes_table_nodeA.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeB:/tmp/setup_routes_table_nodeB.log $TMPDIR/setup_routes_table_nodeB.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerA:/tmp/setup_routes_table_routerA.log $TMPDIR/setup_routes_table_routerA.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerB:/tmp/setup_routes_table_routerB.log $TMPDIR/setup_routes_table_routerB.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerC:/tmp/setup_routes_table_routerC.log $TMPDIR/setup_routes_table_routerC.log

sshpass $SSHP_ARGS scp $SSH_ARGS root@routerC:/tmp/setup_routes_routerC_dump.log $TMPDIR/setup_routes_routerC_dump.log


echo "NodeA -> NodeB" >> $LOGFILE
cat $TMPDIR/setup_routes_nodeA_trace.log >> $LOGFILE
echo -e "\nNodeB -> NodeA" >> $LOGFILE
cat $TMPDIR/setup_routes_nodeB.log >> $LOGFILE

echo -e "\n\nNodeA->NodeB Ping:" >> $LOGFILE
cat $TMPDIR/setup_routes_nodeB_ping.log >> $LOGFILE

echo -e "\n\nRoutes:" >> $LOGFILE
echo -e "\nNodeA:" >> $LOGFILE
cat $TMPDIR/setup_routes_table_nodeA.log >> $LOGFILE
echo -e "\nNodeB:" >> $LOGFILE
cat $TMPDIR/setup_routes_table_nodeB.log >> $LOGFILE
echo -e "\nRouterA:" >> $LOGFILE
cat $TMPDIR/setup_routes_table_routerA.log >> $LOGFILE
echo -e "\nRouterB:" >> $LOGFILE
cat $TMPDIR/setup_routes_table_routerB.log >> $LOGFILE
echo -e "\nRouterC:" >> $LOGFILE
cat $TMPDIR/setup_routes_table_routerC.log >> $LOGFILE


echo -e "\n\nTCPDUMP RouterC:" >> $LOGFILE
cat $TMPDIR/setup_routes_routerC_dump.log >> $LOGFILE






