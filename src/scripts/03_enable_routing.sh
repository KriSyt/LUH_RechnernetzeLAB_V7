#!/bin/bash
# enable routing and disable source addres validation
# enable ICMP redirect nodeB

SSHP_ARGS="-p password"
SSH_ARGS="-o StrictHostKeyChecking=no -o ConnectTimeout=5 -o ConnectionAttempts=3"

LOGFILE="/output/03_enable_routing.log"
TEMPDIR="/output/tmp"
TOOLSDIR="/scripts/tools"


mkdir -p $TEMPDIR

> $LOGFILE

nodeB_if="if0"
routerA_if="if0 if1 if2"
routerB_if="if0 if1 if2"
routerC_if="if1 if2 if3"

sudo sysctl -w net.ipv4.conf.all.accept_redirects=1
### NodeB
sshpass $SSHP_ARGS ssh $SSH_ARGS  root@routerA sudo sysctl -w net.ipv4.conf.all.accept_redirects=1 > /tmp/enableRouting_nodeB.log
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerA sudo sysctl -w net.ipv4.conf.$nodeB_if.accept_redirects=1 >> /tmp/enableRouting_nodeB.log

### Router A
sshpass $SSHP_ARGS scp $SSH_ARGS $TOOLSDIR/enable_routing.sh root@routerA:/tmp/enable_routing.sh
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerA /tmp/enable_routing.sh $routerA_if > /tmp/enableRouting_routerA.log

### Router B
sshpass $SSHP_ARGS scp $SSH_ARGS  $TOOLSDIR/enable_routing.sh root@routerB:/tmp/enable_routing.sh
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerB /tmp/enable_routing.sh $routerB_if  > /tmp/enableRouting_routerB.log

### Router C
sshpass $SSHP_ARGS scp $SSH_ARGS $TOOLSDIR/enable_routing.sh root@routerC:/tmp/enable_routing.sh
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerC /tmp/enable_routing.sh $routerC_if  > /tmp/enableRouting_routerC.log


sleep 1

sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeB:/tmp/enableRouting_nodeB.log > $TEMPDIR/enableRouting_nodeB.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerA:/tmp/enableRouting_routerA.log > $TEMPDIR/enableRouting_routerA.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerB:/tmp/enableRouting_routerB.log > $TEMPDIR/enableRouting_routerB.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerC:/tmp/enableRouting_routerC.log > $TEMPDIR/enableRouting_routerC.log


echo "NodeB" > $LOGFILE
cat $TEMPDIR/enableRouting_nodeB.log > $LOGFILE
echo "RouterA" > $LOGFILE
cat $TEMPDIR/enableRouting_routerA.log > $LOGFILE
echo "RouterB" > $LOGFILE
cat $TEMPDIR/enableRouting_routerB.log > $LOGFILE
echo "RouterC" > $LOGFILE
cat $TEMPDIR/enableRouting_routerC.log > $LOGFILE



>&2  echo "routing enabled on all Routers"

