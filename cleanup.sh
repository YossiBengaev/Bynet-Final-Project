#!/bin/bash

check_null_arg () {
        if [ -z $1 ] #The -z switch will test if the expansion of "$1" is a null string or not
          then  echo -e "No argument supplied \nArgument must be a number of minutes for sleep" ; exit 1
        fi
}

check_too_many_arg () {
        if [ $1 -gt 1 ] #Check for too many args
          then  echo -e "Too many arguments supplied \nArgument must be a number of minutes for sleep" && exit 1
        fi
}

cleanup(){
        scp -o StrictHostKeyChecking=no cleanup.sh ec2-user@${machine}:${HOME_DIR}
        ssh -o StrictHostKeyChecking=no ec2-user@${machine} 'sudo chmod u+x /home/ec2-user/cleanup.sh && /home/ec2-user/cleanup.sh 1'
}

MIN=$1
SEC=$((MIN * 60))
echo "Going to sleep for" $SEC "seconds and then removing all the docker stuff!"
sleep $SEC
docker-compose down
docker container prune -f 
docker image prune -f
docker volume prune -f
