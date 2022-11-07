#!/bin/bash

echo "Going to sleep now "
secs=$((1 * 60))
while [ $secs -gt 0 ]; do
   echo -ne "$secs\033[0K\r"
   sleep 1
   : $((secs--))
done
docker-compose down
