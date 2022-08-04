#!/bin/bash

if [ "${GITLAB_DOMAIN_NAME}" = "" ];then
        read -p "gitlab domain name: " GITLAB_DOMAIN_NAME
fi
if [ "${HOST_IP}" = "" ];then
        HOST_IP=$(hostname -i)
fi

DOLLAR='$'

mkdir -p pki/root
mkdir -p pki/inter
mkdir -p pki/gitlab

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
"usages": ["key encipherment", "server auth", "digital signature", "non repudiation"]
}
}
}
EOF






cfssl gencert -initca pki/root/root-ca.json | cfssljson -bare pki/root/root-ca
cfssl genkey -initca pki/inter/inter.json | cfssljson -bare pki/inter/inter
cfssl sign -ca pki/root/root-ca.pem -ca-key pki/root/root-ca-key.pem --config pki/inter/inter-sign.json pki/inter/inter.csr | cfssljson -bare pki/inter/inter
cat pki/inter/inter.pem pki/root/root-ca.pem > pki/inter/inter-fullchain.crt

cfssl gencert -ca=pki/inter/inter.pem -ca-key=pki/inter/inter-key.pem -config=pki/gitlab/certif-sign.json pki/gitlab/certif.json | cfssljson -bare pki/gitlab/certif

cat pki/gitlab/certif.pem pki/inter/inter-fullchain.crt > pki/gitlab/certif-fullchain.crt



GITLAB_DOMAIN_NAME=${GITLAB_DOMAIN_NAME} envsubst < docker-compose.yaml.template > docker-compose.yaml
