#!/bin/bash

F5FPC=/usr/local/bin/f5fpc

HOST=vpn.rotterdam.nl

command="$F5FPC -s -x -t $HOST"

if [ -n "$USERNAME" ] ; then
	command="$command -u $USERNAME"
fi

if [ -n "$TOKEN_AND_PASSWORD" ] ; then
	command="$command -p $TOKEN_AND_PASSWORD"
fi

nohup $command

sysctl -w net.ipv4.ip_forward=1 > /dev/null
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
# NAT to ontwikkel-VPN
iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination 10.33.252.53:443
iptables -t nat -A POSTROUTING -p tcp -d 10.33.252.53 --dport 443 -j MASQUERADE
