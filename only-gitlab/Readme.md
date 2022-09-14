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




example pipeline for Docker build and push. Registry must be enabled for project

```
# This file is a template, and might need editing before it works on your project.
# This is a sample GitLab CI/CD configuration file that should run without any modifications.
# It demonstrates a basic 3 stage CI/CD pipeline. Instead of real tests or scripts,
# it uses echo commands to simulate the pipeline execution.
#
# A pipeline is composed of independent jobs that run scripts, grouped into stages.
# Stages run in sequential order, but jobs within stages run in parallel.
#
# For more information, see: https://docs.gitlab.com/ee/ci/yaml/index.html#stages
#
# You can copy and paste this template into a new `.gitlab-ci.yml` file.
# You should not add this template to an existing `.gitlab-ci.yml` file by using the `include:` keyword.
#
# To contribute improvements to CI/CD templates, please follow the Development guide at:
# https://docs.gitlab.com/ee/development/cicd/templates.html
# This specific template is located at:
# https://gitlab.com/gitlab-org/gitlab/-/blob/master/lib/gitlab/ci/templates/Getting-Started.gitlab-ci.yml

stages:          # List of stages for jobs, and their order of execution
  - build
  - test
  - deploy

default:
  tags:
    - docker
  image:
    name: alpine


build-job:       # This job runs in the build stage, which runs first.
  stage: build
  image:
    name: gcr.io/kaniko-project/executor:v1.9.0-debug
    entrypoint: [""]
  before_script:
  - |
    echo "-----BEGIN CERTIFICATE-----
    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    -----END CERTIFICATE-----" >> /kaniko/ssl/certs/additional-ca-cert-bundle.crt
  script:
    - /kaniko/executor
      --context "${CI_PROJECT_DIR}"
      --dockerfile "${CI_PROJECT_DIR}/Dockerfile"
      --destination "${CI_REGISTRY_IMAGE}:${CI_COMMIT_BRANCH}-${CI_PIPELINE_ID}"

unit-test-job:   # This job runs in the test stage.
  stage: test    # It only starts when the job in the build stage completes successfully.
  script:
    - echo "Running unit tests... This will take about 60 seconds."
    - sleep 6
    - echo "Code coverage is 90%"

lint-test-job:   # This job also runs in the test stage.
  stage: test    # It can run at the same time as unit-test-job (in parallel).
  script:
    - echo "Linting code... This will take about 10 seconds."
    - sleep 3
    - echo "No lint issues found."

deploy-job:      # This job runs in the deploy stage.
  stage: deploy  # It only runs when *both* jobs in the test stage complete successfully.
  tags:
    - docker
  script:
    - echo "Deploying application..."
    - echo "Application successfully deployed."
```

