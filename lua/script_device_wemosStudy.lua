commandArray = {}

host = "http://192.168.38.236/control"

if (otherdevices['WemosStudy'] == 'On') then
    if (devicechanged['Keuken (ESP)']) then
        temp, hum, bar = string.match(otherdevices['Keuken (ESP)'], "(%d+%.*%d*);(%d+%.*%d*);%d")
        os.execute('curl -s -d "cmd=event,settempkeuken=' .. temp .. '" ' .. host)
    end

    if (devicechanged['Study UK']) then
        temp, hum, bar = string.match(otherdevices['Study UK'], "(%d+%.*%d*);(%d+%.*%d*);%d")
        os.execute('curl -s -d "cmd=event,settempstudy=' .. temp .. '" ' .. host)
    end

    if (devicechanged['Woonkamer ESP']) then
        temp, hum, bar = string.match(otherdevices['Woonkamer ESP'], "(%d+%.*%d*);(%d+%.*%d*);%d")
        os.execute('curl -s -d "cmd=event,settempwoon=' .. temp .. '" ' .. host)
    end

    if (devicechanged['Buiten']) then
        os.execute('curl -s -d "cmd=event,setbuiten=' .. otherdevices['Buiten'] .. '" ' .. host)
    end

    if (devicechanged['Beweging boven']) then
        print(devicechanged['Beweging boven'])
        os.execute('curl -s -d "cmd=OLEDCMD,' .. devicechanged['Beweging boven'] .. '" ' .. host)
    end
end

return commandArray
