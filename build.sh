#!/bin/sh

echo "create switch"

sudo ovs-vsctl del-br ovs

sudo ovs-vsctl add-br ovs
sudo ip link add br type bridge
sudo ip netns add ns1

sudo ip link add name brovs type veth peer name ovsbr
sudo ip link add name ns1br type veth peer name brns1
sudo ip link set ns1br netns ns1

sudo ovs-vsctl add-port ovs enx8857ee229e5c
sudo ovs-vsctl add-port ovs ovsbr

sudo ip link set brovs master br
sudo ip link set enx8857ee229e4d master br
sudo ip link set brns1 master br

sudo ip link set enx8857ee229e5c
sudo ip link set ovs up
sudo ip link set ovsbr up
sudo ip link set brovs up
sudo ip link set enx8857ee229e4d
sudo ip link set brns1 up

sudo ip netns exec ns1 ip link set ns1br up
sudo ip netns exec ns1 ip link set lo up
sudo ip netns exec ns1 ip addr add 192.168.100.10/24 dev ns1ovs

sudo ovs-vsctl set-controller ovs tcp:0.0.0.0:6653
sudo ovs-vsctl set bridge ovs protocols=OpenFlow10


echo "finish!!"
