#!/bin/bash
# Change the rid values below to match the sensors on your devices page in Domoticz

#SendMsgTo=$1
TmpFileName='/home/pi/WeatherFile.txt'
# array of temperature / humidity sensor indexes
declare -a arr=("16" "805")

## now loop through the above array
for index in "${arr[@]}"
do
   ResultString+=`curl 'http://192.168.1.49:8080/json.htm?type=devices&rid='$index 2>/dev/null | /usr/local/bin/jq -r .result[].Name`
   ResultString+=" "
   ResultString+=`curl 'http://192.168.1.49:8080/json.htm?type=devices&rid='$index 2>/dev/null | /usr/local/bin/jq -r .result[].Temp`
   ResultString+="°C, "
#   ResultString+=`curl 'http://'$DomoticzIP':'$DomoticzPort'/json.htm?type=devices&rid='$index 2>/dev/null | jq -r .result[].Humidity`
#   ResultString+="%\n"
done
echo $ResultString
#Outside prediction
ResultString+=" "
ForeCast=`curl 'http://192.168.1.49:8080/json.htm?type=devices&rid=12' 2>/dev/null | /usr/local/bin/jq -r .result[].Forecast`
echo $ForeCast
case "$ForeCast" in
2) ResultString+="⛅️" #Partly Cloudy
	;;
3) ResultString+="☁️" #Cloudy
	;;
*) echo `curl 'http://192.168.1.49:8080/json.htm?type=devices&rid=13' 2>/dev/null | /usr/local/bin/jq -r .result[].ForecastStr`
	;;
esac

#Send
echo -e $ResultString > $TmpFileName
#echo telegram-cli -W -e "send_document SendMsgTo $TmpFileName"
/home/pi/tg/scripts/generic/telegram.sh send_text NameOne $TmpFileName
/home/pi/tg/scripts/generic/telegram.sh send_text NameTwo $TmpFileName