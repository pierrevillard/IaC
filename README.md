# PREREQUIS

You must install: docker, docker-compose
You also need : git, openssl, envsubst, bash  (But these packages are usually already installed on Linux OS)


# Get the stack:

```
git clone https://github.com/pierreilki/IaC.git"
cd IaC
```

# Can be launched with :

```
./deploy.sh
```

This script will ask you for domains used to publish Nexus, Jenkins and Gitlab URLs.
Domain names are needed to configure/generate HTTPs certs/keys and Nginx Proxy redirects.


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

Due to self-signed certs

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
