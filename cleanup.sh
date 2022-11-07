#!/bin/bash

echo "Going to sleep now and the removing all the docker stuff!"
secs=$(($1 * 60))
while [ $secs -gt 0 ]; do
   echo -ne "$secs\033[0K\r"
   sleep 1
   : $((secs--))
done
docker-compose down
docker container prune 
docker image prune 
docker volume prune 
