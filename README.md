# PREREQUIS

You must install: docker, docker-compose and cfssl/cfssljson (https://github.com/cloudflare/cfssl)

You can Install CFSSL/CFSSLJSON with following commands:

```
wget https://github.com/cloudflare/cfssl/releases/download/v1.6.1/cfssljson_1.6.1_linux_amd64
mv cfssljson_1.6.1_linux_amd64 /bin/cfssljson
chmod +x /bin/cfssljson
wget https://github.com/cloudflare/cfssl/releases/download/v1.6.1/cfssl_1.6.1_linux_amd64
mv cfssl_1.6.1_linux_amd64 /bin/cfssl
chmod +x /bin/cfssl

```

You also need : git, openssl, envsubst, bash  (But these packages are usually already installed on Linux OS)


# Get the stack:

```
git clone https://github.com/pierreilki/IaC.git -b
cd IaC
```

# Can be launched with :

With sonar, make sure following commands are run before deploy stack:
```
sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072
ulimit -n 131072
ulimit -u 8192
```


```
NEXUS_DOMAIN_NAME=nexus.local.lan JENKINS_DOMAIN_NAME=sonarqube.local.lan GITLAB_DOMAIN_NAME=gitlab.local.lan ./init.sh
docker-compose up -d
```

This script will ask you for domains used to publish Nexus, Jenkins and Gitlab URLs.
Domain names are needed to configure/generate HTTPs certs/keys and Nginx Proxy redirects.

Note: By default, PKI certs will also trust your devops host IP according to "hostname -i" commande. You can change the default IP by adding HOST_IP=[YOUR_IP} variable

If you use WSL2, add the following entry to `C:\Windows\System32\drivers\etc\hosts` :
```
127.0.0.1 nexus.local.lan sonarqube.local.lan gitlab.local.lan
```
Then open your browser at:
* https://nexus.local.lan
* https://sonarqube.local.lan
* https://gitlab.local.lan

If you wanna validate PKI certs on your host, juste install the 2 following certs as "trusterd CA certs" on your host !
```
 pki/inter/inter-fullchain.crt
 pki/root/root-ca.pem
 ```
# Can be totally destroyed with: 

```
./destroy.sh
```

# Get InitialJenkins Password:

```
cat /var/lib/docker/volumes/iac_jenkins_data/_data/secrets/initialAdminPassword
```
URL: https://${JENKINS_DOMAIN_NAME}


# Get InitialGitlab Password:

```
cat /var/lib/docker/volumes/iac_gitlab_config/_data/initial_root_password
```
Default user: root
URL: https://${GITLAB_DOMAIN_NAME}

IF you don't install your PKI CA/INTER-FULL-CHAIN crt on your host:

```
git -c http.sslVerify=false clone https://${GITLAB_DOMAIN_NAME}/YOUR_GIT_REPO

or

git config --global http.sslVerify false

```
# Get Nexus Password

```
cat /var/lib/docker/volumes/iac_nexus_data/_data/admin.password
```
Default user: admin
URL: https://${NEXUS_DOMAIN_NAME}


# Deploy ETCD

```
docker run -d --name etcd-server \
    --publish 2379:2379 \
    --publish 2380:2380 \
    --env ALLOW_NONE_AUTHENTICATION=yes \
    --env ETCD_ADVERTISE_CLIENT_URLS=http://0.0.0.0:2379 \
    bitnami/etcd:3.4.18
```




# Trust CA for your Host and browser

If you wanna validate PKI certs on your host, juste install the 2 following certs as "trusterd CA certs" on your host !
```
 pki/inter/inter-fullchain.crt
 pki/root/root-ca.pem
 ```
