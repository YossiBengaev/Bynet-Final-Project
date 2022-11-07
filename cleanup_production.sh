#!/bin/bash

MIN=$1
SEC=$((MIN * 60))
echo "Going to sleep for" $SEC "seconds and then removing all the docker stuff!"
sleep $SEC

ssh -o StrictHostKeyChecking=no ec2-user@production 'docker-compose down && docker container prune -f && docker image prune -f && docker volume prune -f'
