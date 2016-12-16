#!/bin/sh

echo "create switch"

sudo ovs-vsctl del-br ovs

sudo ovs-vsctl add-br ovs
sudo ip netns add ns1

sudo ip link add name ns1ovs type veth peer name ovsns1
sudo ip link set ns1ovs netns ns1

sudo ovs-vsctl add-port ovs enx8857ee229e5c
sudo ovs-vsctl add-port ovs enx8857ee229e4d
sudo ovs-vsctl add-port ovs ovsns1

sudo ip link set ovs up
sudo ip link set ovsns1 up
sudo ip link set enx8857ee229e5c
sudo ip link set enx8857ee229e4d

sudo ip netns exec ns1 ip link set ns1ovs up
sudo ip netns exec ns1 ip link set lo up
sudo ip netns exec ns1 ip addr add 172.16.10.200/24 dev ns1ovs

sudo ovs-vsctl set-controller ovs tcp:0.0.0.0:6653
sudo ovs-vsctl set bridge ovs protocols=OpenFlow10


echo "finish!!"

echo "port1: [out]"
echo "port2: [inn]"
echo "port3: ns1"



