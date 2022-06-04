#!/bin/bash

#!/bin/bash

if [ "${NEXUS_DOMAIN_NAME}" = "" ];then
        read -p "nexus domain name: " NEXUS_DOMAIN_NAME
fi
if [ "${JENKINS_DOMAIN_NAME}" = "" ];then
        read -p "jenkins domain name: " JENKINS_DOMAIN_NAME
fi
if [ "${GITLAB_DOMAIN_NAME}" = "" ];then
        read -p "gitlab domain name: " GITLAB_DOMAIN_NAME
fi


NEXUS_DOMAIN_NAME=${NEXUS_DOMAIN_NAME} JENKINS_DOMAIN_NAME=${JENKINS_DOMAIN_NAME} GITLAB_DOMAIN_NAME=${GITLAB_DOMAIN_NAME} DOLLAR='$' envsubst < nginx/nginx.conf.template > nginx/nginx.conf


sudo mkdir -p ./ssl/gitlab
openssl genrsa -out ./ssl/gitlab/tls.key 2048
openssl req -new -x509 -key ./ssl/gitlab/tls.key -out ./ssl/gitlab/tls.cert -days 360 -subj /CN=${GITLAB_DOMAIN_NAME}

sudo mkdir -p ./ssl/nexus
openssl genrsa -out ./ssl/nexus/tls.key 2048
openssl req -new -x509 -key ./ssl/nexus/tls.key -out ./ssl/nexus/tls.cert -days 360 -subj /CN=${NEXUS_DOMAIN_NAME}

sudo mkdir -p ./ssl/jenkins
openssl genrsa -out ./ssl/jenkins/tls.key 2048
openssl req -new -x509 -key ./ssl/jenkins/tls.key -out ./ssl/jenkins/tls.cert -days 360 -subj /CN=${JENKINS_DOMAIN_NAME}

GITLAB_EXTERNAL_URL=https://${GITLAB_DOMAIN_NAME} docker-compose up -d
