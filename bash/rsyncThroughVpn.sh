#!/bin/bash
# From: https://superuser.com/questions/297342/rsync-files-newer-than-1-week
# Usage: You can call the script to fetch last last 3 days with ./rsyncThroughVpn.sh 3 or ./script.sh 3 dry for a dry run.
DAYS=$1
DRYRUN=$2

SOURCEHOST="user@sourceHostOrIp"
SOURCEPATH="/source/path/"

DESTHOST="user@destinationHostOrIp"
DESTPATH="/destination/path/"

MOUNTPOINT="/mnt/point"

## 
echo "Info: Starting rsync script:"
date
echo "======================"

if [[ -z $DAYS ]]; then
  echo "Error: no days argument."
  echo "Please enter the number of days to sync as first argument."
  exit 1
fi

if [[ $DRYRUN = "dry" ]]; then
  DRYRUNCMD="--dry-run"
  echo "Info: Dry run initiated..."
fi

## Mountpoint should be empty before mount
if [[ $(ls -A $MOUNTPOINT) ]]; then
  echo "Error: Mountpoint $MOUNTPOINT is not empty, exit script"
  exit 1
fi

## Mount the destination path with sshfs
echo "Info: Mount $DESTHOST at $MOUNTPOINT"
sshfs -o allow_other,IdentityFile=~/.ssh/id_rsa $DESTHOST:/ $MOUNTPOINT

## Mountpoint should not be empty after mount
if [ "$(ls -A $MOUNTPOINT | wc -l )" -eq 0 ]; then
  echo "Error: Mountpoint $MOUNTPOINT is still empty, mounting probably failed, exit script"
  exit 1
fi

echo "Info: Start rsync"
rsync -avz $DRYRUNCMD --files-from=<(ssh \
    $SOURCEHOST "find $SOURCEPATH \
    -mtime -$DAYS -name *.mkv -type f \
     -printf '%f\n'") \
  $SOURCEHOST:$SOURCEPATH $MOUNTPOINT/$DESTPATH

echo "Info: rsync completed"

## Unmount sshfs
echo "Info: unmount $MOUNTPOINT"
umount $MOUNTPOINT

## Mountpoint should be empty after unmount
if [[ $(ls -A $MOUNTPOINT) ]]; then
  echo "Error: Mountpoint $MOUNTPOINT is not empty after unmount"
  exit 1
fi

echo "Info: sync script completed successfully"
date
echo "====================="
