#!/bin/bash
########################################################
# * https://github.com/sripathikrishnan/redis-rdb-tools
# * https://redis.io/topics/mass-insert
########################################################

if [ $# -lt 2 ]; then
  tput bold; tput setaf 1;
  echo "Uso: time $0 localhost 6379 | tee import_dump.log";
  echo "  Parametros Obligatorios:"
  echo "    Host: localhost"
  echo "    Port: 6379"
  tput sgr0;
  exit 0;
fi

host=$1
port=$2
folder=dump

rm $folder/*
mkdir $folder
echo "--------------------------------------------------------------------------------------"
redis-cli -c -h $host -p $port CLUSTER NODES | grep master
echo "--------------------------------------------------------------------------------------"
listIpsSlots=$(redis-cli -c -h $host -p $port CLUSTER NODES | grep master | awk '{ print $2":"$9 }' | awk -F":" '{ print $1"|"$3 }')

for i in $listIpsSlots
do
  echo "-------------------------------"
  ip=$(echo $i | awk -F"|" '{ print $1 }')
  slot=$(echo $i | awk -F"|" '{ print $2 }')
  echo "IP SLOTS:" $ip" "$slot
  pod=$(kubectl get pods -o wide | grep $ip | awk '{print $1}')
  echo "PODNAME: " $pod
  kubectl exec -it $pod -- cp /bitnami/redis/data/dump.rdb /tmp/dump.rdb.$slot
  kubectl cp $pod:/tmp/dump.rdb.$slot ./$folder/dump.rdb.$slot
done