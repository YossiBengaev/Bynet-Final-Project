#!/bin/bash

RESPONSE=$(curl -Is http://127.0.0.1:5000 | head -n 1)
if [ "$RESPONSE"="HTTP/1.1 200 OK" ]
  then echo "Http response is 200 it is mean the app is running and you are good to go!!"
 else
  echo "Not so fast! you have code status " + $RESPONSE + " please try again... " ; exit 1 
