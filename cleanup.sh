#!/bin/bash

MACHINE=$1
ssh -o StrictHostKeyChecking=no ec2-user@${MACHINE} 'docker-compose down && docker container prune -f && docker image prune -f && docker volume prune -f'
