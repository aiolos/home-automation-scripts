#!/usr/bin/env bash

# TV Off
curl -o /dev/null http://192.168.38.220/control?cmd=IRSEND,SAMSUNG,0xE0E019E6,32 &
# Pioneer Off
#curl -o /dev/null http://192.168.38.220/control?cmd=IRSEND,NEC,0xA55AD827,32 &