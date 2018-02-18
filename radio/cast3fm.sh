#!/usr/bin/env bash

/home/pi/stream2chromecast/stream2chromecast.py -devicename 192.168.38.217 -playurl http://icecast.omroep.nl/3fm-bb-mp3 &

# receiver on
curl -o /dev/null http://192.168.38.220/control?cmd=IRSEND,PIONEER,0xA55A58A7,32,2 &

# Wait till receiver is turned on:
sleep 3s

# receiver A AUX
curl -o /dev/null http://192.168.38.220/control?cmd=IRSEND,PIONEER,0xA55AF20D,32,2 &
