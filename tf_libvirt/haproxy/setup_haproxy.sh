#!/bin/bash

cp haproxy.cfg.template haproxy.cfg

server_id=1
for v in `terraform -chdir=../ output -json | jq .VMs.value | grep -v 'k8wrk' | grep 192 | tr '"' " " | awk '{print $1}'`
do
   echo "   server master${server_id} $v:6443 check check-ssl verify none" >> haproxy.cfg;
   server_id=$((server_id+1))

   scp -i ../private_key.pem server.pem https_server.py run_server.sh ubuntu@${v}:
   ssh -i ../private_key.pem ubuntu@${v} -- 'at -f run_server.sh now'

done

./docker_stop_haproxy.sh


proxy_name="k8s-haproxy"
current_ip=$(ip a | grep -v inet6 | grep inet | grep '10.0.0' | awk '{print $2}' | awk -F '/' '{print $1}')
port_export="${current_ip}:6443:443"
docker run -d --name ${proxy_name}  -v $(pwd)/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg -p ${port_export} haproxy:alpine

