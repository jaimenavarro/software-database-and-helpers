#!/bin/bash

if [ $# -lt 2 ]; then
  tput bold; tput setaf 1;
  echo "--------------------------------------------------------------------"
  echo "Usage: $0 localhost 6379 | tee \$(date -u +%Y-%m-%d-%H-%M-%S).txt ";
  tput sgr0;
  exit 0;
fi

host=$1
port=$2

echo "CHECKING CONNECTION TO REDIS CLUSTER"
nc -vz -w 30 $1 $2 &> /tmp/redis-cluster-connection
let connection_ok=$(grep "succeeded" /tmp/redis-cluster-connection | wc -l)
if [ $connection_ok -eq 0 ]
then
tput bold; tput setaf 1;
  echo "CAN'T CONNECT TO REDIS CLUSTER:" $1":"$2;
  tput sgr0;
  exit 0;
fi

echo "--------------------------------------------------------------------------------------"
redis-cli -c -h $host -p $port CLUSTER NODES
echo "--------------------------------------------------------------------------------------"
listIpsSlotsMasters=$(redis-cli -c -h $host -p $port CLUSTER NODES | grep master | awk '{ print $1":"$2":"$9 }' | awk -F":" '{ print $1"|"$2"|"$4 }')



for i in $listIpsSlotsMasters
do
  idmaster=$(echo $i | awk -F"|" '{ print $1 }')
  ip=$(echo $i | awk -F"|" '{ print $2 }')
  ipslave=$(redis-cli -c -h $host -p $port CLUSTER NODES | grep slave | grep $idmaster | awk '{ print $2":"$4 }' | awk -F":" '{ print $1 }')
  slot=$(echo $i | awk -F"|" '{ print $3 }')
  pod=$(kubectl get pods -o wide | awk '{print $1" "$6}' | grep "$ip"$ | awk '{print $1}')
  podslave=$(kubectl get pods -o wide | awk '{print $1" "$6}' | grep "$ipslave"$ | awk '{print $1}')

  echo "########################################################"
  echo "MASTER                  SLOTS                SLAVE"
  echo  $pod"   "$slot"   "$podslave
  echo "----------------------------------------------------"
  echo  "       MASTER: $pod                       "
  echo "----------------------------------------------------"
  kubectl exec -it $pod -- redis-cli CLUSTER NODES
  echo "----------------------------------------------------"
  kubectl exec -it $pod -- redis-cli CLUSTER INFO | head -9
  echo "----------------------------------------------------"
  kubectl exec -it $pod -- redis-cli info | grep -e connected_clients \
  -e uptime_in_days \
  -e used_memory_human \
  -e used_memory_peak_human \
  -e maxmemory_human \
  -e maxmemory_policy \
  -e rdb_last_bgsave_status \
  -e rdb_bgsave_in_progress \
  -e role \
  -e connected_slaves \
  -e slave0 \
  -e master_link_status \
  -e evicted_keys \
  -e cluster_enabled \
  -e db0
  echo "----------------------------------------------------"
  echo  "       SLAVE: $podslave                       "
  echo "----------------------------------------------------"
  kubectl exec -it $podslave -- redis-cli CLUSTER NODES
  echo "----------------------------------------------------"
  kubectl exec -it $podslave -- redis-cli CLUSTER INFO | head -9
  echo "----------------------------------------------------"
  kubectl exec -it $podslave -- redis-cli info | grep -e connected_clients \
  -e uptime_in_days \
  -e used_memory_human \
  -e used_memory_peak_human \
  -e maxmemory_human \
  -e maxmemory_policy \
  -e rdb_last_bgsave_status \
  -e rdb_bgsave_in_progress \
  -e role \
  -e connected_slaves \
  -e slave0 \
  -e master_link_status \
  -e evicted_keys \
  -e cluster_enabled \
  -e db0
  echo "########################################################"
  
done
