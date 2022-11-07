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
        if [ "$machine" = "test" ]
          then  echo -e "Pass validition args \nDeploy To test server!!!" && copy_to_remote_machine && copy_tests_dir && run_test_script
        elif [ "$machine" = "production" ]
          then  echo -e "Pass validition args\nDeploy to production server!!!" && copy_to_remote_machine && echo "You are running on PRODUCTION ! ! ! ! ! "
        else
          echo "Argument must be [production | test]" && exit 1
        fi
}

copy_to_remote_machine() {
        scp -o StrictHostKeyChecking=no docker-compose.yaml .env ec2-user@${machine}:${HOME_DIR} && run_docker_compose
}

copy_tests_dir() {
        scp -o StrictHostKeyChecking=no -r ${TEST_DIR} ec2-user@${machine}:${HOME_DIR}
}

run_test_script() {
        ssh -o StrictHostKeyChecking=no ec2-user@test '/home/ec2-user/tests/test.sh'
}

run_docker_compose(){
        ssh -o StrictHostKeyChecking=no ec2-user@${machine} 'docker-compose up --no-build -d'
}

# Gobal Variables
HOME_DIR="/home/ec2-user"
JENKINS_DIR="/var/lib/jenkins/workspace/Final-Project"
#"docker-compose.yaml .env"
#${JENKINS_DIR}/${FILE_TO_COPY}
TEST_DIR="/var/lib/jenkins/workspace/Final-Project/tests"

echo -e "Starting deploy script...\nFirst checking valid argument..."
first_arg="$1"
number_of_args="$#"
check_too_many_arg $number_of_args
check_null_arg $first_arg
machine=$first_arg
check_which_machine $machine
