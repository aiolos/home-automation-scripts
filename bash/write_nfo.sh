#!/bin/bash

## Automatically create a .nfo file for the recording just made in TVHeadend
## Configure in TVHeadend as post-recording command: /usr/local/bin/write_nfo.sh "%f" "%t" "%d" %S "%c"

DATUM=`date -d @$4 "+%d-%m-%Y %H:%M"`
cat > ${1%.mkv}.nfo <<-EOF
<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<tvshow>
    <title>$2</title>
    <plot>$DATUM - $5
$3</plot>
    <playcount>0</playcount>
</tvshow>
EOF