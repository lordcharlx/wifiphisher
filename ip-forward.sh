INTERFACE=wlp0s20u1
echo '1' > /proc/sys/net/ipv4/conf/$AP_INTERFACE/forwarding
iptables -t nat -A PREROUTING -d 0/0 -p tcp --dport 80 -j DNAT --to-destination 127.0.0.1:80
iptables -A FORWARD -p tcp -d 0/0 --dport 80 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
