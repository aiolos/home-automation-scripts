#!/usr/bin/env bash

# Save this file in /storage/.config/shutdown.sh on OpenElec

# On OSMC:
# Comment everything except the curl line in this file
# Point to the right location of the script in shut.service
# Save shut.service in /lib/systemd/system/shut.service
# Reload: sudo systemctl daemon-reload
# Check enabled with: sudo systemctl is-enabled shut
# Check status: sudo systemctl status shut
# More info here: https://osmc.tv/wiki/general/running-scripts-on-startup-and-shutdown/

case "$1" in
  halt)
    # halt commands here
    /usr/bin/curl "http://192.168.38.110:8080/json.htm?type=command&param=switchscene&idx=4&switchcmd=Off"
    ;;
  poweroff)
    # poweroff commands here
    /usr/bin/curl "http://192.168.38.110:8080/json.htm?type=command&param=switchscene&idx=4&switchcmd=Off"
    ;;
  reboot)
    # reboot commands here
    ;;
  *)
    # other commands here
    ;;
esac
