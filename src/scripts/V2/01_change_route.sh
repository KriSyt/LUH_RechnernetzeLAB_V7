#!/bin/bash
SSHP_ARGS="-p password"
SSH_ARGS="-o StrictHostKeyChecking=no -o ConnectTimeout=5 -o ConnectionAttempts=3"

ROUTERC_IF="if3"
ROUTERB_IF="if0"

LOGFILE="/output/V2_01_change_route.log"
TEMPDIR="/output/tmp"

> $LOGFILE

LOG_NODEB_CHANGEROUTE="change_route_routerB.log"
LOG_NODEB_TABLE="nodeB_table.log"
LOG_NODEB_PING="nodeB_ping.log"
LOG_ROUTERC_DUMP="routerC_tcp_dump.log"
LOG_ROUTERB_DUMP="routerB_tcp_dump.log"
LOG_NODEB_PING2="nodeB_ping2.log"
LOG_ROUTERC_DUMP2="routerC_tcp_dump2.log"
LOG_ROUTERB_DUMP2="routerB_tcp_dump3.log"
LOG_NODEB_PING3="nodeB_ping3.log"

echo "Changing routes"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo route del -net 192.168.1.0/24 gw 192.168.10.1 > /tmp/$LOG_NODEB_CHANGEROUTE"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo route del -net 192.168.30.0/24 gw 192.168.30.2 >> /tmp/$LOG_NODEB_CHANGEROUTE"

sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo route add -net 192.168.1.0/24 gw 192.168.10.1 metric 10 >> /tmp/$LOG_NODEB_CHANGEROUTE"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo route add -net 192.168.1.0/24 gw 192.168.2.251 metric 0 >> /tmp/$LOG_NODEB_CHANGEROUTE"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo route add -net 192.168.30.0/24 gw 192.168.30.2 >> /tmp/$LOG_NODEB_CHANGEROUTE"

sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo route | grep 192 > /tmp/$LOG_NODEB_TABLE"
echo "Routes changed"
sleep 1
echo "Ping NodeA->NodeB"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@nodeA "ping -q 192.168.2.1 -c4 | grep transmitted > /tmp/$LOG_NODEB_PING"
sleep 4


### Clear Routing Cache
sshpass $SSHP_ARGS ssh root@nodeA "sudo ip route flush cache"
sshpass $SSHP_ARGS ssh root@nodeB "sudo ip route flush cache"


### Ping and dump
echo "Ping and Dump (10s)"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerC "sudo tcpdump -U -i $ROUTERC_IF > /tmp/$LOG_ROUTERC_DUMP &"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerB "sudo tcpdump -U -i $ROUTERB_IF > /tmp/$LOG_ROUTERB_DUMP &"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@nodeB "sudo ip route flush cache"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@nodeB "ping 192.168.1.1 -q -c10 > /tmp/$LOG_NODEB_PING2"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerC "sudo pkill tcpdump"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo pkill tcpdump"
sleep 10


echo "Ping and Dump Metric 5 (10s)"
### Increase metric (5)
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo route del -net 192.168.1.0/24 gw 192.168.2.251 > /tmp/$LOG_NODEB_CHANGEROUTE"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo route add -net 192.168.1.0/24 gw 192.168.2.251 metric 5 >> /tmp/$LOG_NODEB_CHANGEROUTE"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@nodeB "sudo ip route flush cache"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "echo 'Metric: 5' >> /tmp/$LOG_ROUTERB_DUMP"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerC "echo 'Metric: 5' >> /tmp/$LOG_ROUTERC_DUMP"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerC "sudo tcpdump -U -i $ROUTERC_IF >> /tmp/$LOG_ROUTERC_DUMP &"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerB "sudo tcpdump -U -i $ROUTERB_IF >> /tmp/$LOG_ROUTERB_DUMP &"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@nodeB "ping 192.168.1.1 -q -c10 > /tmp/$LOG_NODEB_PING2"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerC "sudo pkill tcpdump"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo pkill tcpdump"
sleep 10

echo "Ping and Dump Metric 10 (10s)"
### Increase metric (5)
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo route del -net 192.168.1.0/24 gw 192.168.2.251 > /tmp/$LOG_NODEB_CHANGEROUTE"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo route add -net 192.168.1.0/24 gw 192.168.2.251 metric 10 >> /tmp/$LOG_NODEB_CHANGEROUTE"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@nodeB "sudo ip route flush cache"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "echo 'Metric: 10' >> /tmp/$LOG_ROUTERB_DUMP"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerC "echo 'Metric: 10' >> /tmp/$LOG_ROUTERC_DUMP"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerC "sudo tcpdump -U -i $ROUTERC_IF >> /tmp/$LOG_ROUTERC_DUMP &"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerB "sudo tcpdump -U -i $ROUTERB_IF >> /tmp/$LOG_ROUTERB_DUMP &"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@nodeB "ping 192.168.1.1 -q -c10 > /tmp/$LOG_NODEB_PING2"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerC "sudo pkill tcpdump"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo pkill tcpdump"
sleep 1

echo "Ping and Dump Metric 15 (10s)"
### Increase metric (5)
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo route del -net 192.168.1.0/24 gw 192.168.2.251 > /tmp/$LOG_NODEB_CHANGEROUTE"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo route add -net 192.168.1.0/24 gw 192.168.2.251 metric 15 >> /tmp/$LOG_NODEB_CHANGEROUTE"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@nodeB "sudo ip route flush cache"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "echo 'Metric: 15' >> /tmp/$LOG_ROUTERB_DUMP"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerC "echo 'Metric: 15' >> /tmp/$LOG_ROUTERC_DUMP"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerC "sudo tcpdump -U -i $ROUTERC_IF >> /tmp/$LOG_ROUTERC_DUMP &"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerB "sudo tcpdump -U -i $ROUTERB_IF >> /tmp/$LOG_ROUTERB_DUMP &"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@nodeB "ping 192.168.1.1 -q -c10 > /tmp/$LOG_NODEB_PING2"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerC "sudo pkill tcpdump"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo pkill tcpdump"
sleep 1

echo "Ping and Dump Metric 20 (10s)"
### Increase metric (5)
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo route del -net 192.168.1.0/24 gw 192.168.2.251 > /tmp/$LOG_NODEB_CHANGEROUTE"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo route add -net 192.168.1.0/24 gw 192.168.2.251 metric 20 >> /tmp/$LOG_NODEB_CHANGEROUTE"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@nodeB "sudo ip route flush cache"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "echo 'Metric: 20' >> /tmp/$LOG_ROUTERB_DUMP"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerC "echo 'Metric: 20' >> /tmp/$LOG_ROUTERC_DUMP"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerC "sudo tcpdump -U -i $ROUTERC_IF >> /tmp/$LOG_ROUTERC_DUMP &"
sshpass $SSHP_ARGS ssh $SSH_ARGS -f root@routerB "sudo tcpdump -U -i $ROUTERB_IF >> /tmp/$LOG_ROUTERB_DUMP &"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@nodeB "ping 192.168.1.1 -q -c10 > /tmp/$LOG_NODEB_PING2"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerC "sudo pkill tcpdump"
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo pkill tcpdump"
sleep 1




#### Reverse Changes
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo route del -net 192.168.1.0/24 gw 192.168.2.251 "
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo route del -net 192.168.1.0/24 gw 192.168.10.1 "
sshpass $SSHP_ARGS ssh $SSH_ARGS root@routerB "sudo route add -net 192.168.1.0/24 gw 192.168.10.1"




echo "download logs"
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerB:/tmp/$LOG_NODEB_CHANGEROUTE $TEMPDIR/$LOG_NODEB_CHANGEROUTE
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerB:/tmp/$LOG_NODEB_TABLE $TEMPDIR/$LOG_NODEB_TABLE
sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeA:/tmp/$LOG_NODEB_PING $TEMPDIR/$LOG_NODEB_PING

sshpass $SSHP_ARGS scp $SSH_ARGS root@routerC:/tmp/$LOG_ROUTERC_DUMP $TEMPDIR/$LOG_ROUTERC_DUMP
sshpass $SSHP_ARGS scp $SSH_ARGS root@routerB:/tmp/$LOG_ROUTERB_DUMP $TEMPDIR/$LOG_ROUTERB_DUMP
sshpass $SSHP_ARGS scp $SSH_ARGS root@nodeB:/tmp/$LOG_NODEB_PING2 $TEMPDIR/$LOG_NODEB_PING2


### Write to LogFile

echo -e "Change Route log:\n" >> $LOGFILE
cat $TEMPDIR/$LOG_NODEB_CHANGEROUTE >> $LOGFILE

echo -e "\nTable RouterB:\n" >> $LOGFILE
cat $TEMPDIR/$LOG_NODEB_TABLE >> $LOGFILE

echo -e "\nPingNodeA->NodeB:\n" >> $LOGFILE
cat $TEMPDIR/$LOG_NODEB_PING >> $LOGFILE

echo -e "\nAfter clearing cache:\n" >> $LOGFILE
echo -e "Ping NodeB->NodeA\n" >> $LOGFILE
cat $TEMPDIR/$LOG_NODEB_PING2 >> $LOGFILE

echo -e "\nDumpRouterB:\n" >> $LOGFILE
cat $TEMPDIR/$LOG_ROUTERB_DUMP >> $LOGFILE
echo -e "\nDumpRouterC:\n" >> $LOGFILE
cat $TEMPDIR/$LOG_ROUTERC_DUMP >> $LOGFILE