#!/bin/bash

## LOCAL/FTP/SCP/MAIL PARAMETERS
SERVER="192.168.1.1"                       # IP of Network disk
USERNAME="username"                         # username of Network disk
PASSWORD="password"                         # FTP password of Network disk
DESTDIR="/volume1/homes/domoticz/backup"    # Destination
## END OF USER CONFIGURABLE PARAMETERS

### Send to Network disk through rsync
rsync -avz -e ssh -r /home/pi/domoticz/backups $USERNAME@$SERVER:$DESTDIR

### Done!
