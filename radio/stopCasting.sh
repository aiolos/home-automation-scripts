#!/usr/bin/env bash

/home/pi/stream2chromecast/stream2chromecast.py -devicename 192.168.38.217 -stop &

# Pioneer off
curl -o /dev/null http://192.168.38.220/control?cmd=IRSEND,PIONEER,0xA55AD827,32,2 &
