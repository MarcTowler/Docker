#!/bin/bash
set -e
ZONE="/etc/bind/db.itslit"
TMP="/tmp/db.itslit.new"
BIND_IP="192.168.1.233"

# Rebuild zone file
cat <<EOF > $TMP
$TTL 604800
@   IN  SOA ns1.itslit. admin.itslit. (
        $(date +%Y%m%d%H) ; Serial
        604800      ; Refresh
        86400       ; Retry
        2419200     ; Expire
        604800 )    ; Negative Cache TTL
@   IN  NS  ns1.itslit.
ns1 IN  A   $BIND_IP
traefik IN  A $BIND_IP
EOF

# Add A records from Docker-gen output
if [ -f /tmp/hosts.txt ]; then
  while read name ip; do
    echo "${name} IN A ${ip}" >> $TMP
  done < /tmp/hosts.txt
fi

mv $TMP $ZONE
rndc reload || echo "Bind reload failed, check if rndc is configured"
echo "DNS zone updated."
