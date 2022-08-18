#!/bin/bash
########################################################
# * https://github.com/sripathikrishnan/redis-rdb-tools
# * https://redis.io/topics/mass-insert
# sshpass -p p0rt0Bell0. rsync -av --progress sdp@172.20.181.37:/usr/local/sdp/domains/mirada-sdp-infrastructure/redis-cluster/scripts/dump/* ./
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
  for file in $(ls ./dump/*$slot)
  do
    echo "Import file: "$file
    echo "--------------------------------------------------------------------------------------"
    echo "Execute this command: kubectl port-forward $pod $port:6379"
    echo "Press any button before continue"
    read
    rdb -c protocol $file | redis-cli -c -h $host -p $port --pipe
  done
done