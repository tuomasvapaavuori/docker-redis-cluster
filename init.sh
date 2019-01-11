#!/bin/bash

set -e

function join_by { local IFS="$1"; shift; echo "$*"; }

if [ -z "$IP" ]; then
    IP=$(hostname -i | awk '{print $1}');
fi

cat > supervisord.conf <<-EOF
[supervisord]
nodaemon=false

EOF

i=0
redis_addresses=()

IFS=',' read -r -a port_array <<< ${REDIS_PORT_LIST}


for port in ${port_array[@]}
do
i=$((i+1))
cat >> supervisord.conf <<-EOF
[program:redis-master-${i}]
command=redis-server --port ${port} --cluster-enabled yes --cluster-config-file redis-master-${i}-nodes.conf --cluster-node-timeout 5000
stdout_logfile=/var/log/supervisor/redis-master-${i}.log
stderr_logfile=/var/log/supervisor/redis-master-${i}.log
autorestart=true

EOF
redis_addresses+=("${IP}:${port}")
done

cp supervisord.conf /etc/supervisor/supervisord.conf
supervisord -c /etc/supervisor/supervisord.conf
rm supervisord.conf
sleep 3

redis_address_str=`join_by ' ' "${redis_addresses[@]}"`
echo "Redis addresses for redis trib: ${redis_address_str}"

yes yes | ./redis-trib.rb create --replicas 1 ${redis_address_str}

tail -f /var/log/supervisor/redis*.log
