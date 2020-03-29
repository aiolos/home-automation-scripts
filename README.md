# Home automation scripts

Just a bunch of scripts used in home automation.
- Use [stream2chromecast](https://github.com/aiolos/stream2chromecast) to use bash and python
 for sending streams to a Chromecast
- Use [ESPEasy](https://github.com/aiolos/ESPEasy) for send IR commands to receivers and televisions
- Various LUA scripts to react on events in Domoticz

Most of these scripts communicate with [Domoticz](www.domoticz.com).

## Re-install Domoticz on the raspberry:
- Install Raspbian (enable SSH on SDcard with file `ssh` on boot partition)
- Set timezone
- Change Password
- Run domoticz installer
- Install Python:
  - sudo apt install python3-serial (for ultraheat script)
- Add crontab
- Arrange authorized keys / set private key
- Test backup
- Setup log2ram
- Test lua scripts
- Setup/Test Telegram
