#/bin/sh
iptables-nft -t nat -C POSTROUTING -o $UPLINK_IFACE -j MASQUERADE || iptables-nft -t nat -A POSTROUTING -o $UPLINK_IFACE -j MASQUERADE
iptables-nft -C FORWARD -i $UPLINK_IFACE -o $AP_IFACE -m state --state RELATED,ESTABLISHED -j ACCEPT || iptables-nft -A FORWARD -i $UPLINK_IFACE -o $AP_IFACE -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables-nft -C FORWARD -i $AP_IFACE -o $UPLINK_IFACE -j ACCEPT || iptables-nft -A FORWARD -i $AP_IFACE -o $UPLINK_IFACE -j ACCEPT
iptables-nft -C FORWARD -i $UPLINK_IFACE -p icmp -j ACCEPT || iptables-nft -iptables -A FORWARD -i $UPLINK_IFACE -p icmp -j ACCEPT
