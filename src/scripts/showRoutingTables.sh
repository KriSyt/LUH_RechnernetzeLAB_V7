#!/bin/bash
SSHP_ARGS="-p password"
SSH_ARGS="-o StrictHostKeyChecking=no -o ConnectTimeout=5 -o ConnectionAttempts=3"

TEMPDIR="/output/tmp"
LOGFILE="/output/RoutingTables.log"
> $LOGFILE

### Generate Routing Tables
sshpass $SSHP_ARGS ssh root@nodeA "route | grep 192 > /tmp/setup_routes_table_nodeA.log"
sshpass $SSHP_ARGS ssh root@nodeB "route | grep 192 > /tmp/setup_routes_table_nodeB.log"
sshpass $SSHP_ARGS ssh root@routerA "route | grep 192 > /tmp/setup_routes_table_routerA.log"
sshpass $SSHP_ARGS ssh root@routerB "route | grep 192 > /tmp/setup_routes_table_routerB.log"
sshpass $SSHP_ARGS ssh root@routerC "route | grep 192 > /tmp/setup_routes_table_routerC.log"


sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeA:/tmp/setup_routes_table_nodeA.log $TMPDIR/setup_routes_table_nodeA.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeB:/tmp/setup_routes_table_nodeB.log $TMPDIR/setup_routes_table_nodeB.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerA:/tmp/setup_routes_table_routerA.log $TMPDIR/setup_routes_table_routerA.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerB:/tmp/setup_routes_table_routerB.log $TMPDIR/setup_routes_table_routerB.log
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerC:/tmp/setup_routes_table_routerC.log $TMPDIR/setup_routes_table_routerC.log

echo -e "\n\nRoutes:" >> $LOGFILE
echo -e "\nNodeA:" >> $LOGFILE
cat $TMPDIR/setup_routes_table_nodeA.log >> $LOGFILE
echo -e "\nNodeB:" >> $LOGFILE
cat $TMPDIR/setup_routes_table_nodeB.log >> $LOGFILE
echo -e "\nRouterA:" >> $LOGFILE
cat $TMPDIR/setup_routes_table_routerA.log >> $LOGFILE
echo -e "\nRouterB:" >> $LOGFILE
cat $TMPDIR/setup_routes_table_routerB.log >> $LOGFILE
echo -e "\nRouterC:" >> $LOGFILE
cat $TMPDIR/setup_routes_table_routerC.log >> $LOGFILE