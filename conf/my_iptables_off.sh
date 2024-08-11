#!/bin/sh

# Allow inbound tcp connection to clients - delete rule
# iptables-nft -C FORWARD -i $UPLINK_IFACE -p tcp -j ACCEPT && iptables-nft -D FORWARD -i $UPLINK_IFACE -p tcp -j ACCEPT
