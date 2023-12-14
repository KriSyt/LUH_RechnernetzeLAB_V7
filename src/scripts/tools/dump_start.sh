#!/bin/bash
# dump_start user host interface


SSHP_ARGS="-p password"
SSH_ARGS="-o StrictHostKeyChecking=no -o ConnectTimeout=5 -o ConnectionAttempts=3"

USER=$1
HOST=$2
IF=$3


sshpass $SSHP_ARGS ssh -f $USER@$HOST "tcpdump -v -U -i $IF > /tmp/$HOST_$IF.log &"


