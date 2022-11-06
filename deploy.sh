#!/bin/bash

check_null_arg () {
        if [ -z $1 ] #The -z switch will test if the expansion of "$1" is a null string or not
          then  echo -e "No argument supplied \nArgument must be [prod | test]" ; exit 1
        fi
}

check_too_many_arg () {
        if [ $1 -gt 1 ] #Check for too many args
          then  echo -e "Too many arguments supplied \nArgument must be [prod | test]" ; exit 1
        fi
}

check_which_machine() {
        machine=$1
        if [ "$machine" = "test" ]
          then  echo -e "Pass validition args \nDeploy To test server!!!" ; deploy_to_test
        elif [ "$machine" = "prod" ]
          then  echo -e "Pass validition args\nDeploy to production server!!!" ; deploy_to_prod
        else
          echo "Argument must be [prod | test]" ; exit 1
        fi
}

copy_compose_file_to_remote_machine() {
    scp -o StrictHostKeyChecking=no docker-compose.yml ec2-user@test:/home/ec2-user/Final-Project
}

deploy_to_test() {
    scp -o StrictHostKeyChecking=no docker-compose.yml ec2-user@test:/home/ec2-user/Final-Project
    exit 0
}

deploy_to_prod() {
    scp -o StrictHostKeyChecking=no docker-compose.yml ec2-user@production:/home/ec2-user/Final-Project
    exit 0
}


echo -e "Starting deploy script...\nFirst checking valid argument..."
first_arg="$1"
number_of_args="$#"
check_too_many_arg $number_of_args
check_null_arg $first_arg
check_which_machine $first_arg
