#/bin/sh
iptables-nft -t nat -C POSTROUTING -o $UPLINK_IFACE -j MASQUERADE && iptables-nft -t nat -D POSTROUTING -o $UPLINK_IFACE -j MASQUERADE
iptables-nft -C FORWARD -i $UPLINK_IFACE -o $AP_IFACE -m state --state RELATED,ESTABLISHED -j ACCEPT && iptables-nft -D FORWARD -i $UPLINK_IFACE -o $AP_IFACE -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables-nft -C FORWARD -i $AP_IFACE -o $UPLINK_IFACE -j ACCEPT && iptables-nft -D FORWARD -i $AP_IFACE -o $UPLINK_IFACE -j ACCEPT
