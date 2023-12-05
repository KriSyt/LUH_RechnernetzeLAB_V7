#!/bin/bash

SSHP_ARGS="-p password"
SSH_ARGS="-o StrictHostKeyChecking=no -o ConnectTimeout=5 -o ConnectionAttempts=3"

mkdir -p /output/tmp


routerA_if="if0 if1 if2"
routerB_if="if0 if1 if2"
routerC_if="if1 if2 if3"

###Router A
sshpass $SSHP_ARGS scp $SSH_ARGS /scripts/tools/enable_routing.sh root@routerA:/tmp/enable_routing.sh
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerA /tmp/enable_routing.sh $routerA_if >> /output/routerA.log

###Router B
sshpass $SSHP_ARGS scp $SSH_ARGS /scripts/tools/enable_routing.sh root@routerB:/tmp/enable_routing.sh
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB /tmp/enable_routing.sh $routerB_if >> /output/routerB.log

###Router C
sshpass $SSHP_ARGS scp $SSH_ARGS /scripts/tools/enable_routing.sh root@routerC:/tmp/enable_routing.sh
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerC /tmp/enable_routing.sh $routerC_if >> /output/routerC.log


echo "routing enabled on all Routers"