#!/bin/bash

SSHP_ARGS="-p password"
SSH_ARGS="-o StrictHostKeyChecking=no -o ConnectTimeout=5 -o ConnectionAttempts=3"


LOGFILE="/output/02_ping.log"
TMPDIR="/output/tmp"
mkdir -p $TMPDIR

> $LOGFILE

echo "ping all nodes (wait 5s)"

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


echo "download log files"

sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeA:/tmp/ping_nodeA.log $TMPDIR/ping_nodeA.log

sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeB:/tmp/ping_nodeB_routerB.log $TMPDIR/ping_nodeB_routerB.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeB:/tmp/ping_nodeB_routerC.log $TMPDIR/ping_nodeB_routerC.log

sshpass $SSHP_ARGS scp $SSH_ARGS root@routerA:/tmp/ping_routerA_nodeA.log $TMPDIR/ping_routerA_nodeA.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerA:/tmp/ping_routerA_routerB.log $TMPDIR/ping_routerA_routerB.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerA:/tmp/ping_routerA_routerC.log $TMPDIR/ping_routerA_routerC.log


sshpass $SSHP_ARGS scp $SSH_ARGS root@routerB:/tmp/ping_routerB_nodeB.log $TMPDIR/ping_routerB_nodeB.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerB:/tmp/ping_routerB_routerA.log $TMPDIR/ping_routerB_routerA.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerB:/tmp/ping_routerB_routerC_direct.log $TMPDIR/ping_routerB_routerC_direct.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerB:/tmp/ping_routerB_routerC_lan0.log $TMPDIR/ping_routerB_routerC_lan0.log

sshpass $SSHP_ARGS scp $SSH_ARGS root@routerC:/tmp/ping_routerC_routerA.log $TMPDIR/ping_routerC_routerA.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerC:/tmp/ping_routerC_routerB_direct.log $TMPDIR/ping_routerC_routerB_direct.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerC:/tmp/ping_routerC_routerB_lan0.log $TMPDIR/ping_routerC_routerB_lan0.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerC:/tmp/ping_routerC_nodeB.log $TMPDIR/ping_routerC_nodeB.log


echo "NodeA->RouterA(192.168.1.250)" >> $LOGFILE
cat $TMPDIR/ping_nodeA.log >> $LOGFILE

echo -e "\nNodeB->RouterB(192.168.2.250)" >> $LOGFILE
cat $TMPDIR/ping_nodeB_routerB.log >> $LOGFILE
echo "NodeB->RouterC(192.168.2.251)" >> $LOGFILE
cat $TMPDIR/ping_nodeB_routerC.log >> $LOGFILE

echo -e "\nRouterA->NodeA(192.168.1.1)" >> $LOGFILE
cat $TMPDIR/ping_routerA_nodeA.log >> $LOGFILE
echo "RouterA->RouterB(192.168.10.2)" >> $LOGFILE
cat $TMPDIR/ping_routerA_routerB.log >> $LOGFILE
echo "RouterA->RouterC(192.168.20.2)" >> $LOGFILE
cat $TMPDIR/ping_routerA_routerC.log >> $LOGFILE

echo -e "\nRouterB->NodeB(192.168.2.1)" >> $LOGFILE
cat $TMPDIR/ping_routerB_nodeB.log >> $LOGFILE
echo "RouterB->RouterA(192.168.10.1)" >> $LOGFILE
cat $TMPDIR/ping_routerB_routerA.log >> $LOGFILE
echo "RouterB->RouterC(192.168.30.2)" >> $LOGFILE
cat $TMPDIR/ping_routerB_routerC_direct.log >> $LOGFILE
echo "RouterB->RouterC(192.168.2.251)" >> $LOGFILE
cat $TMPDIR/ping_routerB_routerC_lan0.log >> $LOGFILE

echo -e "\nRouterC->NodeB(192.168.2.1)" >> $LOGFILE
cat $TMPDIR/ping_routerC_nodeB.log >> $LOGFILE
echo "RouterC->RouterA(192.168.20.1)" >> $LOGFILE
cat $TMPDIR/ping_routerC_routerA.log >> $LOGFILE
echo "RouterC->RouterB(192.168.30.1)" >> $LOGFILE
cat $TMPDIR/ping_routerC_routerB_direct.log >> $LOGFILE
echo "RouterC->RouterB(192.168.2.250)" >> $LOGFILE
cat $TMPDIR/ping_routerC_routerB_lan0.log >> $LOGFILE


