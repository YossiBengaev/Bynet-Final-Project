#!/bin/bash

MIN=$1
SEC=$MIN*60
echo "Going to sleep for" + $SEC +" sec and then removing all the docker stuff!"
#secs=$(($1 * 60))
#while [ $secs -gt 0 ]; do
   #echo -ne "$secs\033[0K\r"
   #sleep 1
   #: $((secs--))
#done
sleep $SEC
docker-compose down
docker container prune -f 
docker image prune -f
docker volume prune -f
