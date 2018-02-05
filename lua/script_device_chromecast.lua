
commandArray = {}

if (devicechanged['Volume Chromecast']) then
    volume = (otherdevices_svalues['Volume Chromecast'] / 300)
    os.execute('/home/pi/stream2chromecast.py -device 192.168.38.12 -setvol ' .. volume .. ' &')
    print('Level : ' .. tonumber(volume))
end

return commandArray

