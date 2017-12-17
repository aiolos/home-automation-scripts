#!/bin/bash

## LOCAL/FTP/SCP/MAIL PARAMETERS
SERVER="192.168.1.1"                        # IP of destination network disk
USERNAME="username"                         # username of destination network disk
PASSWORD="password"                         # FTP password of destination network disk
DESTDIR="/volume1/homes/domoticz/backup"    # Destination path
## END OF USER CONFIGURABLE PARAMETERS

### Send to Network disk through rsync
rsync -avz -e ssh -r /home/pi/domoticz/backups $USERNAME@$SERVER:$DESTDIR

### Done!
