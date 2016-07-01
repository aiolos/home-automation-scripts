commandArray = {}
if (devicechanged['Sensor'] == 'On'
        -- or devicechanged['Groep 1 - Knop 1'] == 'On'
        -- or devicechanged['Groep 1 - Knop 2'] == 'On'
        or devicechanged['AppleTV status - X10D11'] == 'On'
        or devicechanged['AppleTV3 LAN status - X10D12'] == 'On'
        or devicechanged['AppleTV3 WiFi status - X10D12'] == 'On'
        or devicechanged['Status Receiver (Chromecast)'] == 'On'
        or devicechanged['TV status - X10D14'] == 'On'
) then
    commandArray['Iemand Thuis']='On'
    -- print ('Er is iemand thuis')
end

return commandArray
