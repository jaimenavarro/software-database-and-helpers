# Summary

This project is a reference to be able to deploy [Apache Traffic Server](https://trafficserver.apache.org) in Docker container

### Folder structure

```
.
└── cache --> /cache
└── config --> /usr/local/etc/trafficserver

```
* **cache folder:** This folder contains information about cache.

* **config folder:** This folder contains the files configuration to run Apache Traffic Server

### SSL certificate

```
┌─[jaime.navarro@CAS00546]─[~/Escritorio]─[izzi-int] 
└─╾ openssl req -x509 -newkey rsa:4096 -keyout tls.key -out tls.crt -days 3650 -nodes
Generating a RSA private key
...................................................................++++
...................................................................................................................++++
writing new private key to 'tls.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:SP
State or Province Name (full name) [Some-State]:Madrid
Locality Name (eg, city) []:Madrid
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Mirada
Organizational Unit Name (eg, section) []:Mirada
Common Name (e.g. server FQDN or YOUR name) []:mad-int.mirada-cloud.com
Email Address []:jaime.navarro@mirada.tv
```


### Docker Install / Uninstall
```
docker-compose -f docker-compose.yml up
```

```
docker-compose -f docker-compose.yml down
docker volume prune
```

# Configuration for WebClient

### Configure /etc/hosts

```
127.0.0.1 mad-int.mirada-cloud.com
```

### Configure ./conf/remap.config

Point the environment you want to use.

```
regex_map https://(.*).mirada-cloud.com/ https://uat.izzigo.tv/
#regex_map https://(.*).mirada-cloud.com/ https://atni-int.mirada-cloud.com/
#regex_map https://(.*).mirada-cloud.com/ https://ver.zapitv.com/
```

### Open WebClient with Test User

Open the version of the webclient you want to use [https://webclient-dev.mirada-cloud.com/webclient/](https://webclient-dev.mirada-cloud.com/webclient/). Go to **"Secret Menu"** and pick Server **"MAD INT"**. 

