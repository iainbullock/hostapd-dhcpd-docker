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

if [ ! -f /config/interfaces ]; then
 echo -e "${CYAN}[*] Creating default interfaces config file${NOCOLOR}"
 cp /conf/interfaces /config
fi

if [ ! -f /config/dhcpd.conf ]; then
 echo -e "${CYAN}[*] Creating default dhcpd.conf config file${NOCOLOR}"
 cp /conf/dhcpd.conf /config
fi

if [ ! -f /config/hostapd.conf ]; then
 echo -e "${CYAN}[*] Creating default hostapd.conf config${NOCOLOR}"
 cp /conf/hostapd.conf /config
fi

echo -e "${CYAN}[*] Creating config links${NOCOLOR}"
ln -sf /config/interfaces /etc/interfaces
ln -sf /config/dhcpd.conf /etc/dhcp/dhcpd.conf
ln -sf /config/hostapd.conf /etc/hostapd/hostapd.conf

echo -e "${CYAN}[*] Creating iptables rules${NOCOLOR}"
#sh /app/iptables.sh || echo -e "${RED}[-] Error creating iptables rules${NOCOLOR}"

echo -e "${CYAN}[*] Setting wlan0 settings${NOCOLOR}"
#ifdown wlan0
#ifup wlan0

echo -e "${CYAN}[+] Configuration successful! Services will start now${NOCOLOR}"
#dhcpd -4 -f -d wlan0 &
#hostapd /etc/hostapd/hostapd.conf &
pid=$!
wait $pid

#cleanup
