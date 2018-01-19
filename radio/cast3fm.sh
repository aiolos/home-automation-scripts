#!/usr/bin/env bash

/home/pi/stream2chromecast/stream2chromecast.py -devicename 192.168.38.217 -playurl http://icecast.omroep.nl/radio2-bb-mp3 &

# receiver on
curl -o /dev/null http://192.168.38.177/?code=A55A58A7\&p=2\&r=5\&f=40\&d=20 &
# receiver A AUX
curl -o /dev/null http://192.168.38.177/?code=A55AF20D\&p=2\&r=3\&f=40\&d=20 &
