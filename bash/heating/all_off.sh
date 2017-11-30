#!/usr/bin/env bash

# Setpoints to 12 degrees
# IDX Thermostaat: 3459
# IDX Study: 3511

curl -o /dev/null http://192.168.38.110:8080/json.htm?type=command&param=udevice&idx=3459&nvalue=0&svalue=12
curl -o /dev/null http://192.168.38.110:8080/json.htm?type=command&param=udevice&idx=3511&nvalue=0&svalue=13 # Setpoint study

# Turn off all valves
# curl -o /dev/null http://192.168.38.110:8080/json.htm?type=command&param=udevice&idx=3511&nvalue=0&svalue=13 # Living
# curl -o /dev/null http://192.168.38.110:8080/json.htm?type=command&param=udevice&idx=3511&nvalue=0&svalue=13 # Kitchen
