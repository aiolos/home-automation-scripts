-- This script sums the values of 3 power generation devices into one value in Domoticz
--
commandArray = {}

if devicechanged['Omnik 715'] or devicechanged['Omnik 725'] or devicechanged['Diehl (Youless)'] then
   omnik715 = otherdevices_svalues['Omnik 715']
   omnik725 = otherdevices_svalues['Omnik 725']
   diehl = otherdevices_svalues['Diehl (Youless)']
   omnik715Power, omnik715Energy = string.match(otherdevices_svalues['Omnik 715'], "(%d+%.*%d*);(%d+%.*%d*)")
   omnik725Power, omnik725Energy = string.match(otherdevices_svalues['Omnik 725'], "(%d+%.*%d*);(%d+%.*%d*)")
   diehlEnergy, diehlPower = string.match(otherdevices_svalues['Diehl (Youless)'], "(%d+%.*%d*);(%d+%.*%d*)")
   power = (diehlPower + omnik715Power + omnik725Power)
   energy = (diehlEnergy + omnik715Energy + omnik725Energy)
   commandArray[1] = {['UpdateDevice'] = 31 .. "|0|" .. power .. ";" .. energy} -- 31 is the domoticz IDX
end

return commandArray

