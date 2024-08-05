#!/bin/sh

NOCOLOR='\033[0m'
RED='\033[0;31m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'

sigterm_handler () {
  echo -e "${CYAN}[*] Caught SIGTERM/SIGINT!${NOCOLOR}"
  pkill hostapd
  cleanup
  exit 0
}
cleanup () {
  echo -e "${CYAN}[*] Deleting iptables rules...${NOCOLOR}"
  sh /app/iptables_off.sh || echo -e "${RED}[-] Error deleting iptables rules${NOCOLOR}"
  echo -e "${CYAN}[*] Restarting network interface...${NOCOLOR}"
  ifdown wlan0
  ifup wlan0
  echo -e "${GREEN}[+] Successfully exited, byebye! ${NOCOLOR}"
}

trap 'sigterm_handler' TERM INT

# Set default values for environment variables
export UPLINK_IFACE=${UPLINK_IFACE:-eth0}
export AP_IFACE=${AP_IFACE:-wlan0}

echo -e "${CYAN}[*] Configuration variables:${NOCOLOR}"
echo -e "${GREEN}     UPLINK_IFACE=$UPLINK_IFACE ${NOCOLOR}"
echo -e "${GREEN}     AP_IFACE=$AP_IFACE ${NOCOLOR}"

if [ ! -f /config/interfaces ]; then
 echo -e "${CYAN}[*] Creating default interfaces config file${NOCOLOR}"
 cat /conf/interfaces | envsubst > /config/interfaces
fi

if [ ! -f /config/dhcpd.conf ]; then
 echo -e "${CYAN}[*] Creating default dhcpd.conf config file${NOCOLOR}"
 cat /conf/dhcpd.conf | envsubst > /config/dhcpd.conf
fi

if [ ! -f /config/hostapd.conf ]; then
 echo -e "${CYAN}[*] Creating default hostapd.conf config${NOCOLOR}"
 cat /conf/hostapd.conf | envsubst > /config/hostapd.conf
fi

echo -e "${CYAN}[*] Creating config links${NOCOLOR}"
ln -sf /config/interfaces /etc/network/interfaces
ln -sf /config/dhcpd.conf /etc/dhcp/dhcpd.conf
ln -sf /config/hostapd.conf /etc/hostapd/hostapd.conf
touch /var/lib/dhcp/dhcpd.leases
touch /run/dhcp/dhcpd.pid

echo -e "${CYAN}[*] Creating iptables rules${NOCOLOR}"
sh /app/iptables.sh || echo -e "${RED}[-] Error creating iptables rules${NOCOLOR}"
sleep 5

echo -e "${CYAN}[*] Setting $AP_IFACE settings${NOCOLOR}"
ifdown $AP_IFACE
sleep 5
ifup $AP_IFACE
sleep 5

echo -e "${CYAN}[+] Configuration successful! Services will start now${NOCOLOR}"
dhcpd -4 -f -d $AP_IFACE &
hostapd /etc/hostapd/hostapd.conf &
pid=$!
wait $pid

cleanup
