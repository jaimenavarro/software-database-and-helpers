#!/bin/bash
########################################################
# * https://github.com/sripathikrishnan/redis-rdb-tools
# * https://redis.io/topics/mass-insert
# sshpass -p p0rt0Bell0. rsync -av --progress sdp@172.20.181.37:/usr/local/sdp/domains/mirada-sdp-infrastructure/redis-cluster/scripts/dump/* ./
########################################################

if [ $# -lt 3 ]; then
  tput bold; tput setaf 1;
  echo "Uso: time $0 localhost 6379 | tee import_dump.log";
  echo "  Parametros Obligatorios:"
  echo "    Host: localhost"
  echo "    Port: 6379"
  echo "    Patten key to be imported: /stream"
  tput sgr0;
  exit 0;
fi

host=$1
port=$2
pattern=$3


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
  container=$(docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq) | grep $ip | awk '{print $1}' | awk -F"/" '{print $2}')
  echo "CONTAINERNAME: " $container
  for file in $(ls ./dump/*$slot)
  do
    echo "Import file: "$file
    echo "--------------------------------------------------------------------------------------"
    rdb -c protocol $file --no-expire --key $pattern | redis-cli -c -h $ip -p $port --pipe
  done
done