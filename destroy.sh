#!/bin/bash

sudo docker-compose down -v --rmi all --remove-orphans
rm -rf ./ssl
rm -rf ./nginx/nginx.conf
