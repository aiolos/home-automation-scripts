#!/bin/bash
# Change the rid values below to match the sensors on your devices page in Domoticz
DomoticzIp='192.168.1.1'
DomoticzPort='8080'
BotId='YourBotId'
BotKey='YourBotKey'
ChatId='-YourChatId'

$domoticzUrl = 'http://'$DomoticzIp':'$DomoticzPort'/json.htm?type=devices&rid='
# array of temperature / humidity sensor indexes
declare -a arr=("3444" "12")

## now loop through the above array
for index in "${arr[@]}"
do
   ResultString+=`curl $domoticzUrl$index 2>/dev/null | /usr/bin/jq -r .result[].Name`
   ResultString+=" "
   ResultString+=`curl $domoticzUrl$index 2>/dev/null | /usr/bin/jq -r .result[].Temp`
   ResultString+="°C, "
#   ResultString+=`curl $domoticzUrl$index 2>/dev/null | jq -r .result[].Humidity`
#   ResultString+="%\n"
done
echo $ResultString
#Outside prediction
ResultString+=" "
ForeCast=`curl $domoticzUrl'12' 2>/dev/null | /usr/bin/jq -r .result[].Forecast`
#echo $ForeCast
case "$ForeCast" in
2) ResultString+="⛅️" #Partly Cloudy
	;;
3) ResultString+="☁️" #Cloudy
	;;
*) echo `curl $domoticzUrl'13' 2>/dev/null | /usr/bin/jq -r .result[].ForecastStr`
	;;
esac

#Send
curl "https://api.telegram.org/bot${BotId}:${BotKey}/sendMessage?chat_id=${ChatId}&text=${ResultString}"
