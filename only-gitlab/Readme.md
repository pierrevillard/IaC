cat /var/lib/docker/volumes/only-gitlab_gitlab_config/_data/initial_root_password



Deploy a runner
```
docker run -d --name gitlab-runner --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  -v /root/IaC/only-gitlab/pki/gitlab:/etc/gitlab-pki \
  -e "CA_CERTIFICATES_PATH=/etc/gitlab-pki/certif-fullchain.crt" \
  gitlab/gitlab-runner:latest
```

Register a runner:
```
gitlab-runner register --url <REPO_URL> --registration-token <REPO_TOKEN>
```
