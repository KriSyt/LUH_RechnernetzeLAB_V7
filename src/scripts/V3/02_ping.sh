#!/bin/bash

# dump_start user host interface
# dump_end user host interface logfile


ROUTERA_IF="if0"
ROUTERB_IF="if1"
ROUTERC_IF="if1"

TOOLSDIR="/scripts/tools"

SSHP_ARGS="-p password"
SSH_ARGS="-o StrictHostKeyChecking=no -o ConnectTimeout=5 -o ConnectionAttempts=3"

LOGFILE="/output/V3_02_ping.log"
TEMPDIR="/output/tmp"

> $LOGFILE

echo "Pinging"
$TOOLSDIR/dump_start.sh root routerA if0 &
$TOOLSDIR/dump_start.sh root routerB if1 &
$TOOLSDIR/dump_start.sh root routerC if1 &
sleep 1
sshpass $SSHP_ARGS ssh $SSH_ARGS root@nodeB "ping 192.168.1.1 -q -c10 > /tmp/nodeB_ping.log"
sleep 1

$TOOLSDIR/dump_end.sh root routerA if0 $TEMPDIR/routerA_dump.log &
$TOOLSDIR/dump_end.sh root routerB if1 $TEMPDIR/routerB_dump.log &
$TOOLSDIR/dump_end.sh root routerC if1 $TEMPDIR/routerC_dump.log &

sleep 2

echo "Download Logs"
sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeA:/tmp/nodeB_ping.log $TEMPDIR/nodeB_ping.log


echo -e "PING nodeB -> nodeA\n" >> $LOGFILE
cat $TEMPDIR/nodeB_ping.log >> $LOGFILE


echo -e "RouterA dump:\n" >> $LOGFILE
cat $TEMPDIR/routerA_dump.log >> $LOGFILE

echo -e "RouterB dump:\n" >> $LOGFILE
cat $TEMPDIR/routerB_dump.log >> $LOGFILE

echo -e "RouterC dump:\n" >> $LOGFILE
cat $TEMPDIR/routerC_dump.log >> $LOGFILE