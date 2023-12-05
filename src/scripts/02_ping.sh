#!/bin/bash

SSHP_ARGS="-p password"
SSH_ARGS="-o StrictHostKeyChecking=no -o ConnectTimeout=5 -o ConnectionAttempts=3"

mkdir -p /output/tmp
LOGFILE="/output/02_ping.log"

> $LOGFILE

#NodeA
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@nodeA "ping -q 192.168.1.250 -c4 | grep transmitted > /tmp/ping_nodeA.log"

#NodeB
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@nodeB "ping -q 192.168.2.250 -c4 | grep transmitted > /tmp/ping_nodeB_routerB.log"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@nodeB "ping -q 192.168.2.251 -c4 | grep transmitted > /tmp/ping_nodeB_routerC.log"

#RouterA
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerA "ping -q 192.168.1.1 -c4 | grep transmitted > /tmp/ping_routerA_nodeA.log"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerA "ping -q 192.168.10.2 -c4 | grep transmitted > /tmp/ping_routerA_routerB.log"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerA "ping -q 192.168.20.2 -c4 | grep transmitted > /tmp/ping_routerA_routerC.log"

#RouterB
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerB "ping -q 192.168.10.1 -c4 | grep transmitted > /tmp/ping_routerB_routerA.log"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerB "ping -q 192.168.2.1 -c4 | grep transmitted > /tmp/ping_routerB_nodeB.log"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerB "ping -q 192.168.30.2 -c4 | grep transmitted > /tmp/ping_routerB_routerC_direct.log"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerB "ping -q 192.168.2.251 -c4 | grep transmitted > /tmp/ping_routerB_routerC_lan0.log"

#RouterC
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerC "ping -q 192.168.20.1 -c4 | grep transmitted > /tmp/ping_routerC_routerA.log"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerC "ping -q 192.168.30.1 -c4 | grep transmitted > /tmp/ping_routerC_routerB_direct.log"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerC "ping -q 192.168.2.250 -c4 | grep transmitted > /tmp/ping_routerC_routerB_lan0.log"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerC "ping -q 192.168.2.1 -c4 | grep transmitted > /tmp/ping_routerC_nodeB.log"

sleep 5


sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeA:/tmp/ping_nodeA.log /output/tmp/ping_nodeA.log

sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeB:/tmp/ping_nodeB_routerB.log /output/tmp/ping_nodeB_routerB.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeB:/tmp/ping_nodeB_routerC.log /output/tmp/ping_nodeB_routerC.log

sshpass $SSHP_ARGS scp $SSH_ARGS root@routerA:/tmp/ping_routerA_nodeA.log /output/tmp/ping_routerA_nodeA.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerA:/tmp/ping_routerA_routerB.log /output/tmp/ping_routerA_routerB.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerA:/tmp/ping_routerA_routerC.log /output/tmp/ping_routerA_routerC.log


sshpass $SSHP_ARGS scp $SSH_ARGS root@routerB:/tmp/ping_routerB_nodeB.log /output/tmp/ping_routerB_nodeB.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerB:/tmp/ping_routerB_routerA.log /output/tmp/ping_routerB_routerA.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerB:/tmp/ping_routerB_routerC_direct.log /output/tmp/ping_routerB_routerC_direct.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerB:/tmp/ping_routerB_routerC_lan0.log /output/tmp/ping_routerB_routerC_lan0.log

sshpass $SSHP_ARGS scp $SSH_ARGS root@routerC:/tmp/ping_routerC_routerA.log /output/tmp/ping_routerC_routerA.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerC:/tmp/ping_routerC_routerB_direct.log /output/tmp/ping_routerC_routerB_direct.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerC:/tmp/ping_routerC_routerB_lan0.log /output/tmp/ping_routerC_routerB_lan0.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerC:/tmp/ping_routerC_nodeB.log /output/tmp/ping_routerC_nodeB.log

sleep 1

echo "NodeA->RouterA(192.168.1.250)" >> $LOGFILE
cat /output/tmp/ping_nodeA.log >> $LOGFILE

echo "NodeB->RouterB(192.168.2.250)" >> $LOGFILE
cat /output/tmp/ping_nodeB_routerB.log >> $LOGFILE
echo "NodeB->RouterC(192.168.2.251)" >> $LOGFILE
cat /output/tmp/ping_nodeB_routerC.log >> $LOGFILE

echo "RouterA->NodeA(192.168.1.1)" >> $LOGFILE
cat /output/tmp/ping_routerA_nodeA.log >> $LOGFILE
echo "RouterA->RouterB(192.168.10.2)" >> $LOGFILE
cat /output/tmp/ping_routerA_routerB.log >> $LOGFILE
echo "RouterA->RouterC(192.168.20.2)" >> $LOGFILE
cat /output/tmp/ping_routerA_routerC.log >> $LOGFILE

echo "RouterB->NodeB(192.168.2.1)" >> $LOGFILE
cat /output/tmp/ping_routerB_nodeB.log >> $LOGFILE
echo "RouterB->RouterA(192.168.10.1)" >> $LOGFILE
cat /output/tmp/ping_routerB_routerA.log >> $LOGFILE
echo "RouterB->RouterC(192.168.30.2)" >> $LOGFILE
cat /output/tmp/ping_routerB_routerC_direct.log >> $LOGFILE
echo "RouterB->RouterC(192.168.2.251)" >> $LOGFILE
cat /output/tmp/ping_routerB_routerC_lan0.log >> $LOGFILE

echo "RouterC->NodeB(192.168.2.1)" >> $LOGFILE
cat /output/tmp/ping_routerC_nodeB.log >> $LOGFILE
echo "RouterC->RouterA(192.168.20.1)" >> $LOGFILE
cat /output/tmp/ping_routerC_routerA.log >> $LOGFILE
echo "RouterC->RouterB(192.168.30.1)" >> $LOGFILE
cat /output/tmp/ping_routerC_routerB_direct.log >> $LOGFILE
echo "RouterC->RouterB(192.168.2.250)" >> $LOGFILE
cat /output/tmp/ping_routerC_routerB_lan0.log >> $LOGFILE


