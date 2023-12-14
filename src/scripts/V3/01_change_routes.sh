#!/bin/bash




SSHP_ARGS="-p password"
SSH_ARGS="-o StrictHostKeyChecking=no -o ConnectTimeout=5 -o ConnectionAttempts=3"

LOGFILE="/output/V3_01_change_route.log"
TEMPDIR="/output/tmp"

> $LOGFILE

sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo route add -net 192.168.0.0/16 gw 192.168.10.1"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo route del -net 192.168.1.0/24 gw 192.168.10.1"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo route add -net 192.168.1.0/24 gw 192.168.30.2"

sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo route | grep 192.168 > /tmp/routerB_routes.log"


sshpass $SSHP_ARGS scp $SSH_ARGS root@routerB:/tmp/routerB_routes.log $TEMPDIR/routerB_routes.log


echo -e "RouterB Routing Table:\n" >> $LOGFILE
cat $TEMPDIR/routerB_routes.log >> $LOGFILE