#!/bin/bash

sudo mkdir -p ./ssl/gitlab
openssl genrsa -out ./ssl/gitlab/tls.key 2048
openssl req -new -x509 -key ./ssl/gitlab/tls.key -out ./ssl/gitlab/tls.cert -days 360 -subj /CN=gitlab.ilkilab.io

sudo mkdir -p ./ssl/nexus
openssl genrsa -out ./ssl/nexus/tls.key 2048
openssl req -new -x509 -key ./ssl/nexus/tls.key -out ./ssl/nexus/tls.cert -days 360 -subj /CN=nexus.ilkilab.io

sudo mkdir -p ./ssl/jenkins
openssl genrsa -out ./ssl/jenkins/tls.key 2048
openssl req -new -x509 -key ./ssl/jenkins/tls.key -out ./ssl/jenkins/tls.cert -days 360 -subj /CN=jenkins.ilkilab.io

docker-compose up -d
