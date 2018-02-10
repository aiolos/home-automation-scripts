#!/usr/bin/env bash

curl -o /dev/null http://192.168.38.220/control?cmd=IRSEND,PIONEER,0xA55AD02F,32,2 &
