#!/bin/bash

if [ "${HOST_IP}" = "" ];then
        HOST_IP=$(hostname -i)
fi

mkdir -p pki/root
mkdir -p pki/inter
mkdir -p pki/gitlab
mkdir -p pki/nexus
mkdir -p pki/jenkins
mkdir -p pki/registry

cat > ./pki/root/root-ca.json <<EOF
{
"CN": "DevOps Machine Root CA",
"key": {
"algo": "rsa",
"size": 4096
},
"names": [{
"C": "FR",
"L": "Paris",
"O": "DevOps"
}],
"ca": {
"expiry": "87600h"
}
}
EOF

cat > ./pki/inter/inter.json <<EOF
{
"CN": "DevOps Intermediate CA",
"key": {
"algo": "rsa",
"size": 4096
},
"ca": {
"expiry": "87600h"
}
}
EOF

cat > ./pki/inter/inter-sign.json <<EOF
{
"signing": {
"default": {
"expiry": "87600h",
"usages": [
"signing",
"cert sign",
"crl sign"
],
"ca_constraint": {
"is_ca": true
}
}
}
}
EOF

cat > ./pki/gitlab/certif.json <<EOF
{
"CN": "${GITLAB_DOMAIN_NAME}",
"hosts": [
"${GITLAB_DOMAIN_NAME}",
"${HOST_IP}",
"127.0.0.1",
"localhost"
],
"key": {
"algo": "rsa",
"size": 4096
}
}
EOF

cat > ./pki/gitlab/certif-sign.json <<EOF
{
"signing": {
"default": {
"expiry": "87600h",
"usages": ["key encipherment", "server auth"]
}
}
}
EOF




cat > ./pki/nexus/certif.json <<EOF
{
"CN": "${NEXUS_DOMAIN_NAME}",
"hosts": [
"${NEXUS_DOMAIN_NAME}",
"${HOST_IP}",
"127.0.0.1",
"localhost"
],
"key": {
"algo": "rsa",
"size": 4096
}
}
EOF

cat > ./pki/nexus/certif-sign.json <<EOF
{
"signing": {
"default": {
"expiry": "87600h",
"usages": ["key encipherment", "server auth"]
}
}
}
EOF

cat > ./pki/registry/certif.json <<EOF
{
"CN": "${REGISTRY_DOMAIN_NAME}",
"hosts": [
"${REGISTRY_DOMAIN_NAME}",
"${HOST_IP}",
"127.0.0.1",
"localhost"
],
"key": {
"algo": "rsa",
"size": 4096
}
}
EOF

cat > ./pki/registry/certif-sign.json <<EOF
{
"signing": {
"default": {
"expiry": "87600h",
"usages": ["key encipherment", "server auth"]
}
}
}
EOF

cat > ./pki/jenkins/certif.json <<EOF
{
"CN": "${JENKINS_DOMAIN_NAME}",
"hosts": [
"${JENKINS_DOMAIN_NAME}",
"${HOST_IP}",
"127.0.0.1",
"localhost"
],
"key": {
"algo": "rsa",
"size": 4096
}
}
EOF

cat > ./pki/jenkins/certif-sign.json <<EOF
{
"signing": {
"default": {
"expiry": "87600h",
"usages": ["key encipherment", "server auth"]
}
}
}
EOF


cfssl gencert -initca pki/root/root-ca.json | cfssljson -bare pki/root/root-ca
cfssl genkey -initca pki/inter/inter.json | cfssljson -bare pki/inter/inter
cfssl sign -ca pki/root/root-ca.pem -ca-key pki/root/root-ca-key.pem --config pki/inter/inter-sign.json pki/inter/inter.csr | cfssljson -bare pki/inter/inter
cat pki/inter/inter.pem pki/root/root-ca.pem > pki/inter/inter-fullchain.crt

cfssl gencert -ca=pki/inter/inter.pem -ca-key=pki/inter/inter-key.pem -config=pki/jenkins/certif-sign.json pki/jenkins/certif.json | cfssljson -bare pki/jenkins/certif
cfssl gencert -ca=pki/inter/inter.pem -ca-key=pki/inter/inter-key.pem -config=pki/nexus/certif-sign.json pki/nexus/certif.json | cfssljson -bare pki/nexus/certif
cfssl gencert -ca=pki/inter/inter.pem -ca-key=pki/inter/inter-key.pem -config=pki/gitlab/certif-sign.json pki/gitlab/certif.json | cfssljson -bare pki/gitlab/certif
cfssl gencert -ca=pki/inter/inter.pem -ca-key=pki/inter/inter-key.pem -config=pki/registry/certif-sign.json pki/registry/certif.json | cfssljson -bare pki/registry/certif

cat pki/inter/inter-fullchain.crt pki/jenkins/certif.pem > pki/jenkins/certif-fullchain.crt
cat pki/inter/inter-fullchain.crt pki/nexus/certif.pem > pki/nexus/certif-fullchain.crt
cat pki/inter/inter-fullchain.crt pki/gitlab/certif.pem > pki/gitlab/certif-fullchain.crt
cat pki/inter/inter-fullchain.crt pki/registry/certif.pem > pki/registry/certif-fullchain.crt
