case "$1" in
  halt)
    # your commands here
    /usr/bin/curl "http://192.168.1.49:8080/json.htm?type=command&param=switchscene&idx=4&switchcmd=Off"
    ;;
  poweroff)
    # your commands here
    /usr/bin/curl "http://192.168.1.49:8080/json.htm?type=command&param=switchscene&idx=4&switchcmd=Off"
    ;;
  reboot)
    # your commands here
    ;;
  *)
    ;;
esac
