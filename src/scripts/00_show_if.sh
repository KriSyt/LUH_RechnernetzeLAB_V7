#!/bin/bash

SSHP_ARGS="-p password"
SSH_ARGS="-o StrictHostKeyChecking=no -o ConnectTimeout=5 -o ConnectionAttempts=3"

LOGFILE="/output/00_interfaces.log"
TMPDIR="/output/tmp"
mkdir -p $TMPDIR

> $LOGFILE


#NodeA
sshpass $SSHP_ARGS ssh $SSH_ARGS root@nodeA "echo "" > /tmp/nodeA_if.log && ip a |grep 192.168 > /tmp/nodeA_if.log"
sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeA:/tmp/nodeA_if.log $TMPDIR/nodeA_if.log

#NodeB
sshpass $SSHP_ARGS ssh $SSH_ARGS root@nodeB "echo "" > /tmp/nodeB_if.log && ip a |grep 192.168 > /tmp/nodeB_if.log"
sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeB:/tmp/nodeB_if.log $TMPDIR/nodeB_if.log

#RouterA
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerA "echo "" > /tmp/routerA_if.log && ip a |grep 192.168 > /tmp/routerA_if.log"
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerA:/tmp/routerA_if.log $TMPDIR/routerA_if.log

#RouterB
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "echo "" > /tmp/routerB_if.log && ip a |grep 192.168 > /tmp/routerB_if.log"
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerB:/tmp/routerB_if.log $TMPDIR/routerB_if.log

#RouterC
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerC "echo "" > /tmp/routerC_if.log && ip a |grep 192.168 > /tmp/routerC_if.log"
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerC:/tmp/routerC_if.log $TMPDIR/routerC_if.log

sleep 1

echo "NodeA" >> $LOGFILE
cat /output/tmp/nodeA_if.log >> $LOGFILE

echo -e "\nNodeB" >> $LOGFILE
cat /output/tmp/nodeB_if.log >> $LOGFILE

echo -e "\nRouterA" >> $LOGFILE
cat /output/tmp/routerA_if.log >> $LOGFILE

echo -e "\nRouterB" >> $LOGFILE
cat /output/tmp/routerB_if.log >> $LOGFILE

echo -e "\nRouterC" >> $LOGFILE
cat /output/tmp/routerC_if.log >> $LOGFILE
