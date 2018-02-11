t1 = os.time()
s = otherdevices_lastupdate['Beweging boven']
-- returns a date time like 2013-07-11 17:23:12

year = string.sub(s, 1, 4)
month = string.sub(s, 6, 7)
day = string.sub(s, 9, 10)
hour = string.sub(s, 12, 13)
minutes = string.sub(s, 15, 16)
seconds = string.sub(s, 18, 19)

commandArray = {}

t2 = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
difference = (os.difftime (t1, t2))
if (otherdevices['Beweging boven'] == 'Off'
    and otherdevices['Radio boven'] == 'On'
    and difference > 300
    and difference < 400
) then
    commandArray['SendNotification'] = 'Radio boven wordt uitgezet'
    commandArray['Radio boven'] = 'Off'
end

return commandArray
