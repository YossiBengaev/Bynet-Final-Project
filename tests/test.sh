#!/bin/bash

echo "Hello " ; hostname 

curl -Is http://127.0.0.1:5000 | head -n 1
#HTTP=`curl --write-out "%{http_code}\n" --silent --output /dev/null "http://127.0.0.1:8080"`
#echo $HTTP
#if [ "$HTTP" == "200" ]; 
#then echo "Test succedded"
#else
  #echo "Test failed"
#fi
