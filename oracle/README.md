# Summary

This project uses oracle docker container in order to set up a version of **oracle 19c** for your local environment. More details about this docker container image can be found here [Oracle link](https://container-registry.oracle.com/). To make this oracle image available for us, it has been uploaded to:
 * (**Mirada VPN**) dev-artifactory-exe:80/jaimenavarro/oracle-ee-19c
 * (**Internet**) jaimenavarro/oracle-ee-19c
 
# Folder structure
* **docker-compose:** This folder contains information to deploy **oracle-19c** using docker-compose.

* **kubernetes:** This folder contains information to deploy **oracle-19c** using kubectl.

* **scripts:** This folder contains scripts to donwload and import latest SDP dump from DF into your **oracle-19c**.



## Folder docker-compose
Install oracle in docker. 

```
cd docker-compose
docker-compose -f docker-compose-oracle-ee-19-installed.yml up
```
* PORTs: 1521,5550 [https://localhost:5500/em/](https://localhost:5500/em/)
* ORACLE_PWD=system
* ORACLE_SID=ORCLCDB
* USER: *mirada*, *mirada_srm*, *mirada_sm*
* DATA_PUMP_DIR: ./db/dumps -> /mnt
* TABLESPACE USERS: 3 files (96 GB) 

## Folder kubernetes
Install oracle in kubernetes. (storageClassName: "rook-ceph-block")

```
cd kubernetes
kubectl apply -f statefulset-oracle-19c.yaml
```
* PORTs: 1521,5550 [https://localhost:5500/em/](https://localhost:5500/em/)
* ORACLE_PWD=system
* ORACLE_SID=ORCLCDB
* USER: *mirada*, *mirada_srm*, *mirada_sm*
* DATA_PUMP_DIR: /mnt
* TABLESPACE USERS: 3 files (96 GB)

## Folder scripts
Download and import the latest dump file from IZZI DF in you **oracle-19c** instance. This action will take 2-3 hours.

* **FOR DOCKER**

```
cd scripts
./import_dump_docker_from_brisa.sh
```

* **FOR K8S**

```
cd scripts
./import_dump_k8s.sh
```

---
***
---

# First start
You will have to wait at least 15-20 minutes, so you need to see the following logs.

```
oracle-ee-19c | The Oracle base remains unchanged with value /opt/oracle
oracle-ee-19c | #########################
oracle-ee-19c | DATABASE IS READY TO USE!
oracle-ee-19c | #########################
oracle-ee-19c | The following output is now a tail of the alert.log:
oracle-ee-19c | ALTER SYSTEM SET local_listener='' SCOPE=BOTH;
oracle-ee-19c |    ALTER PLUGGABLE DATABASE ORCLPDB1 SAVE STATE
oracle-ee-19c | Completed:    ALTER PLUGGABLE DATABASE ORCLPDB1 SAVE STATE
oracle-ee-19c | 
oracle-ee-19c | XDB initialized.
```

# Tested With
## OS
```
└─╾ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:  Ubuntu 20.04.2 LTS
Release:  20.04
Codename: focal
```


## Docker
```
└─╾ docker version
Client: Docker Engine - Community
 Version:           19.03.6
 API version:       1.40
 Go version:        go1.12.16
 Git commit:        369ce74a3c
 Built:             Thu Feb 13 01:27:49 2020
 OS/Arch:           linux/amd64
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          19.03.6
  API version:      1.40 (minimum version 1.12)
  Go version:       go1.12.16
  Git commit:       369ce74a3c
  Built:            Thu Feb 13 01:26:23 2020
  OS/Arch:          linux/amd64
  Experimental:     false

```
## Docker-compose
```
docker-compose version
docker-compose version 1.28.5, build c4eb3a1f
docker-py version: 4.4.4
CPython version: 3.7.10
OpenSSL version: OpenSSL 1.1.0l  10 Sep 2019
```

## kubectl and k8s cluster
```
kubectl version
Client Version: version.Info{Major:"1", Minor:"17", GitVersion:"v1.17.4", GitCommit:"8d8aa39598534325ad77120c120a22b3a990b5ea", GitTreeState:"clean", BuildDate:"2020-03-12T21:03:42Z", GoVersion:"go1.13.8", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"17", GitVersion:"v1.17.4", GitCommit:"8d8aa39598534325ad77120c120a22b3a990b5ea", GitTreeState:"clean", BuildDate:"2020-03-12T20:55:23Z", GoVersion:"go1.13.8", Compiler:"gc", Platform:"linux/amd64"}
```