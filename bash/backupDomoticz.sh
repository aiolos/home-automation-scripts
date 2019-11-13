#!/bin/bash
SERVER="192.168.38.x"
USERNAME="domoticzbackup"
DESTDIR="/volume1/Backup/domoticz" # Path to your backup folder
DOMO_IP="192.168.38.y" # Domoticz IP
DOMO_PORT="8080"       # Domoticz port

### END OF USER CONFIGURABLE PARAMETERS
TIMESTAMP=`/bin/date +%Y%m%d%H%M%S`
BACKUPFILE="domoticz_$TIMESTAMP.db" # backups will be named "domoticz_YYYYMMDDHHMMSS.db.gz"
BACKUPFILEGZ="$BACKUPFILE".gz

### Create backup and ZIP it
echo "Get backup"
/usr/bin/curl -s http://$DOMO_IP:$DOMO_PORT/backupdatabase.php > /var/log/$BACKUPFILE
echo "Backup finished, start zipping"
gzip -1 /var/log/$BACKUPFILE
tar -zcvf /var/log/domoticz_scripts_$TIMESTAMP.tar.gz /home/pi/domoticz/scripts/
echo "Zipping finished"

### Send to Network disk through SCP
echo "Start copy to $DESTDIR"
scp -i /home/pi/.ssh/id_rsa /var/log/$BACKUPFILEGZ $USERNAME@$SERVER:$DESTDIR
scp -i /home/pi/.ssh/id_rsa /var/log/domoticz_scripts_$TIMESTAMP.tar.gz $USERNAME@$SERVER:$DESTDIR
echo "Finished copy"

### Remove temp backup file
echo "Removing files"
/bin/rm /var/log/$BACKUPFILEGZ
/bin/rm /var/log/domoticz_scripts_$TIMESTAMP.tar.gz
echo "All done"
### Done!
