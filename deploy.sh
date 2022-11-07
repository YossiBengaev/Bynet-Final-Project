#!/bin/bash

check_null_arg () {
        if [ -z $1 ] #The -z switch will test if the expansion of "$1" is a null string or not
          then  echo -e "No argument supplied \nArgument must be [prod | test]" ; exit 1
        fi
}

check_too_many_arg () {
        if [ $1 -gt 1 ] #Check for too many args
          then  echo -e "Too many arguments supplied \nArgument must be [prod | test]" && exit 1
        fi
}

check_which_machine() {
        if [ "$MACHINE" = "test" ]
          then  echo -e "Pass validition args \nDeploy To test server!!!" && copy_to_remote_machine && run_docker_compose && copy_tests_dir 
        elif [ "$MACHINE" = "production" ]
          then  echo -e "Pass validition args\nDeploy to production server!!!" && copy_to_remote_machine && echo "You are running on PRODUCTION ! ! ! ! ! " && run_docker_compose
        else
          echo "Argument must be [production | test]" && exit 1
        fi
}

copy_to_remote_machine() {
        scp -o StrictHostKeyChecking=no ${FILES_TO_COPY} ec2-user@${MACHINE}:${HOME_DIR} 
}

copy_tests_dir() {
        scp -o StrictHostKeyChecking=no -r ${TEST_DIR} ec2-user@${MACHINE}:${HOME_DIR} && run_test_script
}

run_test_script() {
        ssh -o StrictHostKeyChecking=no ec2-user@test '/home/ec2-user/tests/test.sh'
}

run_docker_compose(){
        ssh -o StrictHostKeyChecking=no ec2-user@${MACHINE} 'docker-compose up --no-build -d'
}

echo -e "Starting deploy script...\nFirst checking valid argument..."

# Gobal Variables
HOME_DIR="/home/ec2-user"
JENKINS_DIR="/var/lib/jenkins/workspace/Final-Project"
TEST_DIR="/var/lib/jenkins/workspace/Final-Project/tests"
FILES_TO_COPY="docker-compose.yaml .env cleanup_test.sh cleanup_production.sh"
FIRST_ARG="$1"
NUM_OF_ARGS="$#"

check_too_many_arg $NUM_OF_ARGS
check_null_arg $FIRST_ARG
MACHINE=$FIRST_ARG
check_which_machine $MACHINE
