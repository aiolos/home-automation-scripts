
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

if (otherdevices['Iemand Thuis'] == 'On') then
    --      commandArray['Iemand Thuis'] = 'On'
    os.execute('/home/pi/display_minute.py &')
end

t2 = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
difference = (os.difftime (t1, t2))
if (otherdevices['Iemand Thuis'] == 'Off'
        and difference > 60
        and difference < 200
) then
    os.execute('/home/pi/display_off.py &')
    --      commandArray['Iemand Thuis'] = 'Off'
    --      commandArray['SendNotification']='Display uitgeschakeld'
end

return commandArray

