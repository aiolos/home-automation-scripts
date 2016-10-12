#!/usr/bin/env python
# -*- coding: us-ascii -*-
# vim:ts=4:sw=4:softtabstop=4:smarttab:expandtab
#
"""Dumb clock"""

import os
import sys
import math
import time
import datetime
import json
import urllib2
import re
import httplib, urllib
from pylcdsysinfo import LCDSysInfo, TextLines, TextLines, BackgroundColours, TextColours


def clock_loop(bg=None, fg=None):
    update_display_period = 1  # number of seconds to wait before updating display
    floor = math.floor  # minor optimization

    if bg is None:
        bg = BackgroundColours.BLACK
    if fg is None:
        fg = TextColours.WHITE

    line_num = 1

    d = LCDSysInfo()
    d.clear_lines(TextLines.ALL, bg)
    d.dim_when_idle(False)
    d.set_brightness(127)
    d.save_brightness(127, 255)
    d.set_text_background_colour(bg)

    jsonAfdak = domoticzData(805)
    jsonBuiten = domoticzData(16)
    jsonBinnen = domoticzData(447)
    jsonPower = domoticzData(616)

    d.display_text_on_line(2, 'Buiten:' + jsonBuiten['result'][0]['Data'], False, None, fg)
    d.display_text_on_line(3, 'Afdak:' + jsonAfdak['result'][0]['Data'], False, None, fg)
    d.display_text_on_line(4, 'Binnen:' + jsonBinnen['result'][0]['Data'], False, None, fg)
    d.display_text_on_line(5, 'Verbruik:' + jsonPower['result'][0]['Usage'], False, None, fg)
    d.display_text_on_line(6, 'Vandaag:' + jsonPower['result'][0]['CounterToday'], False, None, fg)

    #print(jsonBuiten['Result']['Name'])
    print(jsonBuiten['result'][0]['Data'])
    timeout = time.time() + 60*2

    while 1:
        clock_str = str(datetime.datetime.now()).split('.')[0]
        d.display_text_on_line(line_num, clock_str, False, None, fg)

        if (time.time() > timeout):
            break
        # Work out when to wake up for the next round/whole (non-fractional) time
        start_time = time.time()
        future_time = floor(start_time) + update_display_period  # pure float math
        sleep_time = future_time - start_time
        time.sleep(sleep_time)

    print('stopped after timeout')
    d.clear_lines(TextLines.ALL, bg)
    d.dim_when_idle(False)
    d.set_brightness(0)
    d.save_brightness(0, 255)
    d.set_text_background_colour(bg)

def domoticzData(idx):
    """
    Get the Domoticz device information.
    """
    url = "http://192.168.1.49/json.htm?type=devices&rid=%s" % (idx)
    req = urllib2.Request(url)
    reqData = urllib2.urlopen(req, timeout=5).read()
    data = json.loads(reqData)

    return data

def main(argv=None):
    if argv is None:
        argv = sys.argv

    clock_loop()

    return 0


if __name__ == "__main__":
    sys.exit(main())