#!/usr/bin/env bash

MOPIDY='http://192.168.38.225:6680/mopidy/rpc'

curl -X POST -H Content-Type:application/json -d '{"method": "core.playback.stop","jsonrpc": "2.0","params": {},"id": 1}' ${MOPIDY}
