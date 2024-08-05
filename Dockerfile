FROM alpine:3.20.2

# install dependencies
RUN apk update && apk add --no-cache \
  hostapd iw dhcp iptables envsubst

# Copy configs and scripts
RUN mkdir /conf /app /run/dhcp
ADD conf/* /conf
ADD app/* /app
RUN chmod +x /app/start.sh

CMD [ "/app/start.sh" ]
