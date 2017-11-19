# EE BrightBox 2 Domoticz script

(Copied from https://github.com/mtearle/ee-brightbox2-stats)
Simple script to extract EE BrightBox 2 statistics and send them to domoticz

Place config in /etc/brightbox.cfg

Add a dummy device to Domoticz, with type Custom Sensor. The Axis label should be MBit. 

## Example config

```
[brightbox]
host = 10.1.1.1
user = admin
password = password

[domoticz]
host = 10.1.1.2
port = 8080
downloadidx = 3496
uploadidx = 3497
```
