#!/bin/bash

sudo docker-compose down -v --rmi all --remove-orphans
rm -rf ./pki
rm -rf ./nginx
rm -rf docker-compose.yaml
