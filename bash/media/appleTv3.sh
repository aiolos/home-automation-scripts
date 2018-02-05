#!/usr/bin/env bash

# Receiver On
#curl -o /dev/null http://192.168.38.220/control?cmd=IRSEND,NEC,0xA55A58A7,32 &

# TV On
curl -o /dev/null http://192.168.38.220/control?cmd=IRSEND,SAMSUNG,0xE0E09966,32 &

# Receiver AppleTV3 input
#curl -o /dev/null http://192.168.38.220/control?cmd=IRSEND,NEC,0xA55A3AC5,32 &

# Samsung HDMI3
curl -o /dev/null http://192.168.38.220/control?cmd=IRSEND,SAMSUNG,0xE0E043BC,32 &
