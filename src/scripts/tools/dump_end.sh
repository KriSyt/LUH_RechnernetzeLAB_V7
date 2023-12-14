#!/bin/bash
# dump_end user host interface logfile

SSHP_ARGS="-p password"
SSH_ARGS="-o StrictHostKeyChecking=no -o ConnectTimeout=5 -o ConnectionAttempts=3"

USER=$1
HOST=$2
IF=$3
LOGFILE=$4



sshpass $SSHP_ARGS ssh $USER@$HOST "pkill tcpdump"
sleep 1

echo "download dump"

sshpass $SSHP_ARGS scp $SSH_ARGS $USER@$HOST:/tmp/$HOST_$IF.log $LOGFILE