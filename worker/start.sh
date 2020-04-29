#!/bin/bash
set -e

/wait

get_ip() {
    host $1 | awk '{print $4;exit;}'
}

echo "-- Initialize worker --"
if [ -f "/id_rsa.pub" ]; then
    cat /id_rsa.pub >/root/.ssh/authorized_keys
fi

echo "Fixing hosts"
HOST=$(hostname -f)
IP=$(get_ip ${HOST})
echo "IP: $IP, HOSTNAME: $HOST"
echo "Total worker: $WORKER_COUNT"
sed -e "/${IP}/d" /etc/hosts >/tmp/hosts

for ((i=1; i<=WORKER_COUNT; i++)); do
    WORKER_HOST="cluster-worker-${i}.cluster-network"
    WORKER_IP=$(get_ip ${WORKER_HOST})
    echo "$WORKER_IP" "$WORKER_HOST" >>/tmp/hosts
done
cat /tmp/hosts >/etc/hosts

touch /var/run/worker.init
echo "-- Initialized --"
echo "-- /etc/hosts --"
cat /etc/hosts

exec "$@"
