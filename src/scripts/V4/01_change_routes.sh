#!/bin/bash

# dump_start user host interface
# dump_end user host interface logfile

TOOLSDIR="/scripts/tools"


ROUTERA_IF="if1"
ROUTERB_IF="if2"
ROUTERC_IF="if1"



SSHP_ARGS="-p password"
SSH_ARGS="-o StrictHostKeyChecking=no -o ConnectTimeout=5 -o ConnectionAttempts=3"

ROUTERC_IF="if3"
ROUTERB_IF="if0"

LOGFILE="/output/V4_01_change_route.log"
TEMPDIR="/output/tmp"

> $LOGFILE

# NodeB
sshpass $SSHP_ARGS ssh $SSH_ARGS root@nodeB "sudo route add -net 192.168.50.0/24 gw 192.168.2.250"
#RouterA
sshpass $SSHP_ARGS ssh $SSH_ARGS root@RouterA "sudo route add -net 192.168.50.0/24 gw 192.168.10.2"
#RouterB
sshpass $SSHP_ARGS ssh $SSH_ARGS root@RouterB "sudo route add -net 192.168.50.0/24 gw 192.168.30.2"
#RouterC
sshpass $SSHP_ARGS ssh $SSH_ARGS root@RouterC "sudo route add -net 192.168.50.0/24 gw 192.168.20.1"



echo "Pinging"
$TOOLSDIR/dump_start.sh root routerA if0 &
$TOOLSDIR/dump_start.sh root routerB if1 &
$TOOLSDIR/dump_start.sh root routerC if1 &
sleep 1
sshpass $SSHP_ARGS ssh $SSH_ARGS root@nodeB "ping 192.168.50.10 -c1 > /tmp/nodeB_ping.log"
sleep 1

$TOOLSDIR/dump_end.sh root routerA if0 $TEMPDIR/routerA_dump.log &
$TOOLSDIR/dump_end.sh root routerB if1 $TEMPDIR/routerB_dump.log &
$TOOLSDIR/dump_end.sh root routerC if1 $TEMPDIR/routerC_dump.log &

sleep 2

echo "Download Logs"
sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeB:/tmp/nodeB_ping.log $TEMPDIR/nodeB_ping.log

echo -e "Ping: NodeB -> NodeA:\n" >> $LOGFILE
cat $TEMPDIR/nodeB_ping.log >> $LOGFILE

echo -e "RouterA dump:\n" >> $LOGFILE
cat $TEMPDIR/routerA_dump.log >> $LOGFILE

echo -e "RouterB dump:\n" >> $LOGFILE
cat $TEMPDIR/routerB_dump.log >> $LOGFILE

echo -e "RouterC dump:\n" >> $LOGFILE
cat $TEMPDIR/routerC_dump.log >> $LOGFILE
