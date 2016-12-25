#!/bin/sh

echo "create switch"

sudo ovs-vsctl del-br ovs

sudo ovs-vsctl add-br ovs
sudo ip link add brg type bridge
sudo ip netns add ns1

sudo ip link add name brgovs type veth peer name ovsbrg
sudo ip link add name ns1brg type veth peer name brgns1
sudo ip link set ns1brg netns ns1

sudo ovs-vsctl add-port ovs enx8857ee229e5c
sudo ovs-vsctl add-port ovs ovsbrg

sudo ip link set brgovs master brg
sudo ip link set enx8857ee229e4d master brg
sudo ip link set brgns1 master brg

sudo ip link set enx8857ee229e5c
sudo ip link set ovs up
sudo ip link set ovsbrg up
sudo ip link set brgovs up
sudo ip link set enx8857ee229e4d
sudo ip link set brgns1 up

sudo ip netns exec ns1 ip link set ns1brg up
sudo ip netns exec ns1 ip link set lo up
sudo ip netns exec ns1 ip addr add 192.168.100.10/24 dev ns1brg

sudo ovs-vsctl set-controller ovs tcp:0.0.0.0:6653
sudo ovs-vsctl set bridge ovs protocols=OpenFlow10


echo "finish!!"
