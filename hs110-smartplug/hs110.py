#!/usr/bin/env python
#
# TP-Link Wi-Fi Smart Plug Protocol Client
# For use with TP-Link HS110: energy monitor
#
# Gets current power (W) and cumulative energy (kWh)
# and sends to Domoticz

import socket
import argparse
import json
import urllib
import urllib2

# ip, port, and command for HS110
ip = '<IP of HS110>'
port = 9999
cmd = '{"emeter":{"get_realtime":{}}}'

# Domoticz command stub and IDx of HS110
baseURL = 'http://<Domoticz IP:port>/json.htm?type=command&param=udevice&nvalue=0'
HSIdx = <Domoticz IDx of HS110>

# Encryption and Decryption of TP-Link Smart Home Protocol
# XOR Autokey Cipher with starting key = 171
def encrypt(string):
   key = 171
   result = "\0\0\0\0"
   for i in string:
      a = key ^ ord(i)
      key = a
      result += chr(a)
   return result

def decrypt(string):
   key = 171
   result = ""
   for i in string:
      a = key ^ ord(i)
      key = ord(i)
      result += chr(a)
   return result

def domoticzrequest (url):
   request = urllib2.Request(url)
#   request.add_header("Authorization", "Basic %s" % base64string)
   response = urllib2.urlopen(request)
   return None;

# Send command and receive reply
try:
   sock_tcp = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
   sock_tcp.connect((ip, port))
   sock_tcp.send(encrypt(cmd))
   data = sock_tcp.recv(2048)
   sock_tcp.close()

#   print "Sent:     ", cmd
   result = decrypt(data[4:])
   jsonData = json.loads(result)
#   print "Received: "
#   print json.dumps(jsonData, indent=4, sort_keys=True)
   power = jsonData['emeter']['get_realtime']['power']
   total = jsonData['emeter']['get_realtime']['total'] * 1000
#   print power, total
except socket.error:
   quit("Cound not connect to host " + ip + ":" + str(port))

# Send data to Domoticz
try:
    url = baseURL + "&idx=%s&svalue=%s;%s" % (HSIdx, power, total)
    domoticzrequest(url)
except urllib2.URLError, e:
   print e.code