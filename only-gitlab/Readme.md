cat /var/lib/docker/volumes/only-gitlab_gitlab_config/_data/initial_root_password



Deploy a runner

```
docker run -d --name gitlab-runner --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  -v /root/IaC/only-gitlab/pki/gitlab:/etc/gitlab-pki \
  -e "CA_CERTIFICATES_PATH=/etc/gitlab-pki/certif-fullchain.crt" \
  --add-host={GITLAB-DNS}:GITLAB-IP \
  gitlab/gitlab-runner:v15.3.0
```

Register a runner:

```
gitlab-runner register --url <REPO_URL> --registration-token <REPO_TOKEN>
```
Fichier tolm DU RUNNER
Ajouter :
```
[[runners]]
...
  [runners.docker]
  ...
    privileged = true
    extra_hosts = ["repo.mydomain.com:172.23.8.182"]
```

ADD gitlab CRT to host:

```
cp ../IaC/only-gitlab/pki/gitlab/certif-fullchain.crt /etc/ssl/certs/
```
