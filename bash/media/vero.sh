#!/usr/bin/env bash

# Receiver On
curl -o /dev/null http://192.168.38.220/control?cmd=IRSEND,PIONEER,0xA55A58A7,32,2 &

# TV On
curl -o /dev/null http://192.168.38.220/control?cmd=IRSEND,SAMSUNG,0xE0E09966,32 &

# Wait till receiver and TV are turned on:
sleep 2s

# Receiver AppleTV input
curl -o /dev/null http://192.168.38.220/control?cmd=IRSEND,PIONEER,0xA55AA15E,32,2 &

# Samsung HDMI3
curl -o /dev/null http://192.168.38.220/control?cmd=IRSEND,SAMSUNG,0xE0E043BC,32 &
