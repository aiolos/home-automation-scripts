commandArray = {}
studyTemp, studyHum, studyBar = string.match(otherdevices_svalues['Study UK'], "(%d+%.*%d*);(%d+%.*%d*);(%d+%.*%d*)")

if (otherdevices['study_radiator_mag_aan'] == 'On'
    and otherdevices['Radiator boven'] == 'Off'
    and ((studyTemp - 0.5) < tonumber(otherdevices_svalues['Study']))
) then
        commandArray['Radiator boven']='On'
        print ('Zet radiator boven aan')
end

if (otherdevices['study_radiator_mag_aan'] == 'On'
    and otherdevices['Radiator boven'] == 'On'
    and (tonumber(studyTemp) >= otherdevices_svalues['Study'])
) then
        commandArray['Radiator boven']='Off'
        print ('Zet radiator boven uit: temperatuur bereikt ')
end

if (otherdevices['study_radiator_mag_aan'] == 'Off'
    and otherdevices['Radiator boven'] == 'On'
) then
        commandArray['Radiator boven']='Off'
        print ('Zet radiator boven uit: override')
end

return commandArray
