-- Check whether devices are not being updated for a long time

function timedifference (timestring)
    t1 = os.time{
        year = string.sub(timestring, 1, 4),
        month = string.sub(timestring, 6, 7),
        day = string.sub(timestring, 9, 10),
        hour = string.sub(timestring, 12, 13),
        min = string.sub(timestring, 15, 16),
        sec = string.sub(timestring, 18, 19)
    }
    return os.difftime (os.time(), t1)
end

commandArray = {}
counter = 0
temperatureDevices = {
    'Buiten',
    'Woonkamer',
    'Woonkamer (eye)',
    'Badkamer',
    'Keuken',
    'Study UK',
    'Temperatuur regenmeter',
    'BMP ESP',
}
for i, temperatureDevice in ipairs(temperatureDevices) do
    if (timedifference(otherdevices_lastupdate[temperatureDevice]) > 7200
    and timedifference(otherdevices_lastupdate[temperatureDevice]) < 7260
    ) then
        counter = counter + 1
        commandArray[counter] = {
            ['SendNotification'] = 'Sinds ' .. otherdevices_lastupdate[temperatureDevice] .. ' geen update van ' .. temperatureDevice
        }
    end
end

usageDevices = {'kWh meter Sale'}
for i, usageDevice in ipairs(usageDevices) do
    if (timedifference(otherdevices_lastupdate[usageDevice]) > 1800
    and timedifference(otherdevices_lastupdate[usageDevice]) < 1860
    ) then
        counter = counter + 1
        commandArray[counter] = {
            ['SendNotification'] = 'Sinds ' .. otherdevices_lastupdate[usageDevice] .. ' geen update van ' .. usageDevice
        }
    end
end

return commandArray
