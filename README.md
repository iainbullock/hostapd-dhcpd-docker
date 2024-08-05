# hostapd-dhcpd-docker

For my personal use, not publically supported

Inspiration from https://fwhibbit.es/automatic-access-point-with-docker-and-raspberry-pi-zero-w

Source code is on github at https://github.com/iainbullock/hostapd-dhcpd-docker/tree/main
## Installation and Setup ##

1 - Issue the following command as root:
```shell
sysctl net.ipv4.ip_forward
```
If the result is zero, issue the following command to enable IPv4 forwarding:
```shell
sysctl net.ipv4.ip_forward=1
```
and make it permanent by editing `/etc/sysctl.conf` to ensure the following line exists and is not commented out:
```
# Uncomment the next line to enable packet forwarding for IPv4
net.ipv4.ip_forward=1
```
2 - Create Docker volume `hostapd-dhcpd`:
```shell
docker volume create hostapd-dhcpd
```
3 - Download docker-compose.yml
```shell
curl -O https://raw.githubusercontent.com/iainbullock/hostapd-dhcpd-docker/main/docker-compose.yml
```
4 - Change the environment variables in `docker-compose.yml` to reflect your setup. AP_IFACE should be set to the interface name of your Access Point wifi device (default wlan0). UPLINK_IFACE should be set to the interface name of the connection to your existing network (default eth0)
5 - Start the container:
```shell
docker compose up -d
```
6 - Further configuration of hostapd and dhcpd can be done by editing the config files in <DOCKER_VOLUME_ROOT>/hostapd-dhcpd/_data
<br /><br />
