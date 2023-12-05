#!/bin/bash

SSHP_ARGS="-p password"
SSH_ARGS="-o StrictHostKeyChecking=no -o ConnectTimeout=5 -o ConnectionAttempts=3"
NOOF_SCRIPT="/scripts_remote/disable_so.sh"

mkdir -p /output/tmp
LOGFILE="/output/01_disable_offload.log"

nodeA_if="if0"
nodeB_if="if0"
routerA_if="if0 if1 if2"
routerB_if="if0 if1 if2"
routerC_if="if1 if2 if3"


> $LOGFILE

sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@nodeA "$NOOF_SCRIPT $nodeA_if > /tmp/noof_nodeA.log"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@nodeB "$NOOF_SCRIPT $nodeB_if > /tmp/noof_nodeB.log"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerA "$NOOF_SCRIPT $routerA_if > /tmp/noof_routerA.log"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerB "$NOOF_SCRIPT $routerB_if > /tmp/noof_routerB.log"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerC "$NOOF_SCRIPT $routerC_if > /tmp/noof_routerC.log"


sleep 8
sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeA:/tmp/noof_nodeA.log /output/tmp/noof_nodeA.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeB:/tmp/noof_nodeB.log /output/tmp/noof_nodeB.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerA:/tmp/noof_routerA.log /output/tmp/noof_routerA.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerB:/tmp/noof_routerB.log /output/tmp/noof_routerB.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerC:/tmp/noof_routerC.log /output/tmp/noof_routerC.log

sleep 1

echo "NodeA" >> $LOGFILE
cat /output/tmp/noof_nodeA.log >>  $LOGFILE

echo "NodeB" >> $LOGFILE
cat /output/tmp/noof_nodeB.log >>  $LOGFILE

echo "RouterA" >> $LOGFILE
cat /output/tmp/noof_routerA.log >>  $LOGFILE

echo "RouterB" >> $LOGFILE
cat /output/tmp/noof_routerA.log >>  $LOGFILE

echo "RouterC" >> $LOGFILE
cat /output/tmp/noof_routerA.log >>  $LOGFILE



