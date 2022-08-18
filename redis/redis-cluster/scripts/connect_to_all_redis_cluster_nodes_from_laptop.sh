#!/bin/bash

if [ $# -lt 2 ]; then
  tput bold; tput setaf 1;
  echo "Linux commands required: nc, ip, ifconfig, redis-cli, kubectl, socat"
  echo "Port 0.0.0.0:6379 not allocated"
  echo "--------------------------------------------------------------------"
  echo "Usage: $0 localhost 6379 ";
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

echo "CHECKING LOCAL PORT 6379"
nc -vz -w 30 localhost 6379 &> /tmp/redis-cluster-connection
let connection_ok=$(grep "succeeded" /tmp/redis-cluster-connection | wc -l)
if [ $connection_ok -eq 1 ]
then
tput bold; tput setaf 1;
  echo "MUST FREE LOCAL PORT 6379";
  tput sgr0;
  exit 0;
fi

echo "CREATING A VIRTUAL NETWORK INTERFACE: eth-redis"
sudo ip link add eth-redis type dummy
ip link show eth-redis
sudo ifconfig eth-redis hw ether C8:D7:4A:4E:47:50
sudo ip link set dev eth-redis up

echo "--------------------------------------------------------------------------------------"
redis-cli -c -h $host -p $port CLUSTER NODES
echo "--------------------------------------------------------------------------------------"
listIpsSlots=$(redis-cli -c -h $host -p $port CLUSTER NODES | awk '{ print $2":"$9 }' | awk -F":" '{ print $1"|"$3 }')

let j=0
for i in $listIpsSlots
do
  echo "-------------------------------"
  ip=$(echo $i | awk -F"|" '{ print $1 }')
  slot=$(echo $i | awk -F"|" '{ print $2 }')
  echo "IP SLOTS NUMBER:" $ip" "$slot" "$j
  pod=$(kubectl get pods -o wide | awk '{print $1" "$6}' | grep "$ip"$ | awk '{print $1}')
  echo "PODNAME: " $pod
  #-------------------------------
  # Create virtual interface
  sudo ip addr add $ip/32 brd + dev eth-redis label eth-redis:$j
  #-------------------------------
  # Create port-forward
  kubectl port-forward $pod 6379$j:6379 &> /dev/null &
  #----------------------------------------------------------
  # Create socket connection between each VI --> port-forward
  socat TCP4-LISTEN:6379,bind=$ip,fork,reuseaddr TCP4:localhost:6379$j &> /dev/null &
  
  let j=j+1
done

echo "---------------------------------------------------------------"
echo "              VIRTUAL NETWORK INTERFACE: eth-redis             "
echo "             You should see one line for each redis node       "
echo "---------------------------------------------------------------"
ifconfig | grep -A 1 "eth-redis:"
echo "---------------------------------------------------------------"

echo "---------------------------------------------------------------"
echo "                       PORT FORWARD                            "
echo "             You should see one line for each redis node       "
echo "---------------------------------------------------------------"
ps -ef | grep kubectl | grep "kubectl port-forward" | grep -v grep
echo "---------------------------------------------------------------"

echo "---------------------------------------------------------------"
echo "                      INTERNAL SOCKETS                         "
echo "             You should see one line for each redis node       "
echo "---------------------------------------------------------------"
ps -ef  | grep socat | grep -v grep
echo "---------------------------------------------------------------"


echo "#################################################################"
echo "#################################################################"
echo "Do you want to remove all previous step up? y/n";
read answer
if [ $answer == "y" ]; then
sudo ip link delete eth-redis type dummy
killall socat
killall kubectl
fi

echo "---------------------------------------------------------------"
echo "              VIRTUAL NETWORK INTERFACE: eth-redis             "
ifconfig | grep -A 1 eth-redis
echo "---------------------------------------------------------------"

echo "---------------------------------------------------------------"
echo "                       PORT FORWARD                            "
ps -ef | grep kubectl | grep "kubectl port-forward" | grep -v grep
echo "---------------------------------------------------------------"

echo "---------------------------------------------------------------"
echo "                      INTERNAL SOCKETS                         "
ps -ef  | grep socat | grep -v grep
echo "---------------------------------------------------------------"

