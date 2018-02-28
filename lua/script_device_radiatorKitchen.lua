commandArray = {}
kitchenTemp, kitchenHum, kitchenBar = string.match(otherdevices_svalues['Keuken'], "(%d+%.*%d*);(%d+%.*%d*);(%d+%.*%d*)")

if (otherdevices['keuken_radiator_mag_aan'] == 'On'
    and otherdevices['Radiator keuken'] == 'Off'
    and ((kitchenTemp - 0.5) < tonumber(otherdevices_svalues['Setpoint Keuken']))
) then
        commandArray['Radiator boven']='On'
        print ('Zet radiator keuken aan')
end

if (otherdevices['keuken_radiator_mag_aan'] == 'On'
    and otherdevices['Radiator keuken'] == 'On'
    and (tonumber(kitchenTemp) >= tonumber(otherdevices_svalues['Setpoint Keuken']))
) then
        commandArray['Radiator keuken']='Off'
        print ('Zet radiator keuken uit: temperatuur bereikt ')
end

if (otherdevices['keuken_radiator_mag_aan'] == 'Off'
    and otherdevices['Radiator keuken'] == 'On'
) then
        commandArray['Radiator keuken']='Off'
        print ('Zet radiator keuken uit: override')
end

return commandArray
