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
        if [ "$machine" = "test" ]
          then  echo -e "Pass validition args \nDeploy To test server!!!" ; echo "scp -o StrictHostKeyChecking=no "$JENKINS_DIR"/"FILE_TO_COPY" ec2-user@"$machine":"$HOME_DIR""
        elif [ "$machine" = "prod" ]
          then  echo -e "Pass validition args\nDeploy to production server!!!" ; copy_to_remote_machine
        else
          echo "Argument must be [prod | test]" ; exit 1
        fi
}

copy_to_remote_machine() {
    echo "scp -o StrictHostKeyChecking=no "$JENKINS_DIR"/"FILE_TO_COPY" ec2-user@"$machine":"$HOME_DIR""
    scp -o StrictHostKeyChecking=no ${JENKINS_DIR}/${FILE_TO_COPY} ec2-user@${machine}:${HOME_DIR}
}

# Gobal Variables
HOME_DIR="/home/ec2-user"
JENKINS_DIR="/var/lib/jenkins/workspace/final-project"
SECRET_KEY="${HOME_DIR}/.ssh/id_rsa.pub"
FILE_TO_COPY="aaa"

echo -e "Starting deploy script...\nFirst checking valid argument..."
first_arg="$1"
number_of_args="$#"
check_too_many_arg $number_of_args
check_null_arg $first_arg
machine=$first_args
check_which_machine $machine
