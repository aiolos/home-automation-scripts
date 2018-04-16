commandArray = {}

host = "http://192.168.38.236/control"

if (otherdevices['Beweging boven'] == 'On'
    and (devicechanged['Achterdeur'] == 'On'
        or devicechanged['Achterdeur'] == 'Open')
) then
    commandArray['SendNotification'] = 'Achterdeur ' .. devicechanged['Achterdeur']
end

return commandArray
