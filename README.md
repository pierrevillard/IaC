# Get the stack:

```
git clone https://github.com/pierreilki/IaC.git"
cd IaC
```

# Can be launched with :

```
GITLAB_EXTERNAL_URL=http://IP_DOCKER_HOST docker-compose up -d"
```


# Can be totally destroyed with: 

```
"docker-compose down -v --rmi all --remove-orphans"
```

# Get InitialJenkins Password:

```
cat /var/lib/docker/volumes/iac_jenkins_data/_data/secrets/initialAdminPassword
```
URL: http://10.20.30.10:8080/


# Get InitialGitlab Password:

```
cat /var/lib/docker/volumes/iac_gitlab_config/_data/initial_root_password
```
Default user: root
URL: http://10.20.30.10/


# Deploy ETCD

```
docker run -d --name etcd-server \
    --publish 2379:2379 \
    --publish 2380:2380 \
    --env ALLOW_NONE_AUTHENTICATION=yes \
    --env ETCD_ADVERTISE_CLIENT_URLS=http://0.0.0.0:2379 \
    bitnami/etcd:3.4.18
```

URL: http://10.20.30.10:2379