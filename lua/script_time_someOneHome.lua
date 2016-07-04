t1 = os.time()
s = otherdevices_lastupdate['Iemand Thuis']
-- returns a date time like 2013-07-11 17:23:12

year = string.sub(s, 1, 4)
month = string.sub(s, 6, 7)
day = string.sub(s, 9, 10)
hour = string.sub(s, 12, 13)
minutes = string.sub(s, 15, 16)
seconds = string.sub(s, 18, 19)

commandArray = {}

if (otherdevices['Groep 1 - Knop 1'] == 'On'
        or otherdevices['Groep 1 - Knop 2'] == 'On'
        or otherdevices['AppleTV status - X10D11'] == 'On'
        or otherdevices['AppleTV3 LAN status - X10D12'] == 'On'
        or otherdevices['AppleTV3 WiFi status - X10D12'] == 'On'
        or otherdevices['Status Receiver (Chromecast)'] == 'On'
        or otherdevices['TV status - X10D14'] == 'On'
) then
    commandArray['Iemand Thuis'] = 'On'
end

t2 = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
difference = (os.difftime (t1, t2))
if (otherdevices['Iemand Thuis'] == 'On' and difference > 1800 and difference < 1900) then
    -- commandArray['SendNotification']='10 minuten geen activiteit!'
    commandArray['Iemand Thuis'] = 'Off'
end

return commandArray
