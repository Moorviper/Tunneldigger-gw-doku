#!/bin/bash

ifconfig bat0 up 10.185.0.1/18
ip rule add iif bat0 table ffrh
ip rule add from 10.185.0.0/18 table ffrh
ip rule add to 10.185.0.0/18 table ffrh
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv4.icmp_errors_use_inbound_ifaddr=1
iptables -A FORWARD -o tun+ -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1292 -m comment --comment "ipv4-mss-fix" --mss 1293:1536
iptables -t nat -A POSTROUTING -o tun0 -s 10.185.0.0/18 -j MASQUERADE
#iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
batctl gw_mode server 300mbit/300mbit
systemctl restart isc-dhcp-server
# wait until vpn is connected
sleep 25
ip route add 10.185.0.0/18 dev bat0 table ffrh
ip route add default via 10.6.1.1 table ffrh
