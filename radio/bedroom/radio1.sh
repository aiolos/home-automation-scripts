#!/bin/bash

# Start playing radio 1
curl -X POST -H Content-Type:application/json -d '{"method": "core.playback.play",  "jsonrpc": "2.0", "params": { "tl_track": null, "tlid": 1 }, "id": 1 }' http://192.168.38.225:6680/mopidy/rpc
