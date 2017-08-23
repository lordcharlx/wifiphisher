set -x
INTERFACE=wlp0s20u1
pid=$( create_ap --list-running | grep $INTERFACE | awk '{print $1}' )
kill $pid
create_ap --list-running


AP_INTERFACE=wlp0s20u1
echo '0' > /proc/sys/net/ipv4/conf/$AP_INTERFACE/forwarding
