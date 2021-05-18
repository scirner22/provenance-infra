#!/bin/bash

PERSISTENT_PEERS="\"edd69f41a2f08176940fe9c5c1b0a6a2ba2de9d6@ec2-54-243-127-104.compute-1.amazonaws.com:26656,79751af0f23fc85ce7ad3043df4754f44ca448e8@ec2-34-196-74-141.compute-1.amazonaws.com:26656,75c00c611a43d1adb0775c5cd210d0d36503d02f@ec2-52-202-14-221.compute-1.amazonaws.com:26656\""

sed -i "s/persistent_peers\ =.*/persistent_peers\ =\ $PERSISTENT_PEERS/" /home/ubuntu/config/config.toml

service supervisor restart
