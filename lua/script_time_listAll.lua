-- this script logs all variables to the log
-- Please note: If you miss a device, try restarting domoticz...

function LogVariables(x,depth,name)
    for k,v in pairs(x) do
        if (depth>0) or ((string.find(k,'device')~=nil) or (string.find(k,'variable')~=nil) or
        (string.sub(k,1,4)=='time') or (string.sub(k,1,8)=='security')) then
            if type(v)=="string" then print(name.."['"..k.."'] = '"..v.."'") end
            if type(v)=="number" then print(name.."['"..k.."'] = "..v) end
            if type(v)=="boolean" then print(name.."['"..k.."'] = "..tostring(v)) end
            if type(v)=="table" then LogVariables(v,depth+1,k); end
        end
    end
end
-- call with this command
LogVariables(_G,0,'');

