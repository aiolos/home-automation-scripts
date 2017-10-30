#!/bin/bash
# From: https://superuser.com/questions/297342/rsync-files-newer-than-1-week
# Usage: Fetch last 3 days with ./rsyncThroughVpn.sh 3 or ./rsyncThroughVpn.sh 3 dry for a dry run.
TIME=$1
DRYRUN=$2

## 
echo "Starting rsync script:"
date
echo "======================"

if [[ -z $TIME ]]; then
  echo "Error: no time argument."
  echo "Please enter the number of days to sync."
  exit 1
fi

if [[ $DRYRUN = "dry" ]]; then
  DRYRUNCMD="--dry-run"
  echo "Dry run initiated..."
fi

# Mount with sshfs
echo "Mount sshfs"
sshfs -o allow_other,IdentityFile=~/.ssh/id_rsa user@destination:/ /mnt/path

echo "Start rsync"
rsync -avz $DRYRUNCMD --files-from=<(ssh \
    user@source "find /media/recordings/path \
    -mtime -$TIME -name *.mkv -type f \
     -printf '%f\n'") \
  user@source:/media/recordings/path/ /mnt/path/recordings/.

echo "rsync completed"

## Unmount sshfs
echo "unmount sshfs"
umount /mnt/path
echo "sync script completed"
date
echo "====================="