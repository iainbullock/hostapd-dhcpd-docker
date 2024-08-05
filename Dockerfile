FROM alpine:3.20.2

# install dependencies
RUN apk update && apk add --no-cache \
  hostapd iw dhcp iptables

# Copy configs and scripts
RUN mkdir /conf /app
ADD conf/* /conf

# Copy scripts
ADD app/* /app

CMD [ "/app/start.sh" ]
