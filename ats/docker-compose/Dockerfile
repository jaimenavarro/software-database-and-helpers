FROM centos:8

ARG ats_version

RUN yum update -y
RUN yum install -y pkgconfig libtool gcc gcc-c++ make openssl openssl-devel pcre libcap flex hwloc lua zlib curl tcl-devel pcre-devel bzip2

COPY --chown=root:root ./trafficserver-${ats_version}.tar.bz2 /root/

WORKDIR /root/

RUN tar -xvf trafficserver-${ats_version}.tar.bz2

WORKDIR /root/trafficserver-${ats_version}

RUN ./configure && make && make install

##########################################################
# Removed default configuration 
# It will be used files inside ./config
##########################################################
RUN rm -fr /usr/local/etc/trafficserver/*

EXPOSE 80
EXPOSE 443

# Start!
CMD ["/usr/local/bin/traffic_server","-k","-K"]
