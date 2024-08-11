#!/bin/sh

# Allow inbound tcp connection to clients
# iptables-nft -C FORWARD -i $UPLINK_IFACE -p tcp -j ACCEPT || iptables-nft -A FORWARD -i $UPLINK_IFACE -p tcp -j ACCEPT
