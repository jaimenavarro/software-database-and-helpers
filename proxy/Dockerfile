FROM ubuntu:jammy
MAINTAINER Jaime Navarro <jaime.navarro.santapau@gmail.com>

RUN apt-get update 

RUN apt-get -y install openssh-server sshpass net-tools apt-utils inetutils-ping traceroute nmap bind9-utils dnsutils socat curl

RUN mkdir -p /run/sshd
RUN chmod 0755 /run/sshd

RUN useradd user
RUN echo "user:pass" | chpasswd

CMD ["/bin/bash", "-c", "/usr/sbin/sshd ; echo wait a few seconds; sleep 10 ;sshpass -p pass ssh -o 'StrictHostKeyChecking=no' user@localhost -D 9200 -N"]