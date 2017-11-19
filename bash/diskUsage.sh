#!/bin/sh
## See https://www.domoticz.com/forum/viewtopic.php?t=15243
df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $6 " - " $1 }' | while read output;
do
  # echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge 80 ]; then
    msg="Running out of space \"$partition ($usep%)\" on $(hostname)"
    curl -s --connect-timeout 2 --max-time 5 "https://api.telegram.org/[botId]:[key]/sendMessage?chat_id=[chat_id]&text=$msg" > /dev/null
    # echo $msg
  fi
done
