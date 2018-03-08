#!/bin/bash

URL=$(curl 'http://mhoom.enri.nl/mhoom.m3u')
PAYLOAD='{"jsonrpc": "2.0", "id": 1, "method": "core.tracklist.add" , "params": {"uri": "'${URL}'"}}'
MOPIDY='http://192.168.38.225:6680/mopidy/rpc'

# Start playing radio 1
curl -X POST -H Content-Type:application/json -d '{"method": "core.tracklist.clear","jsonrpc": "2.0","params": {},"id": 1}' ${MOPIDY}
curl -X POST -H Content-Type:application/json -d "${PAYLOAD}" ${MOPIDY}
curl -X POST -H Content-Type:application/json -d '{"method": "core.playback.play",  "jsonrpc": "2.0", "params": { "tl_track": null, "tlid": 1 }, "id": 1 }' ${MOPIDY}
curl -X POST -H Content-Type:application/json -d '{"method": "core.mixer.set_volume",  "jsonrpc": "2.0", "params": { "volume": 100 }, "id": 1 }' ${MOPIDY}
