##
## This class disable (or enable again) ipv6 in the kernel. After a system
## reboot confirm with "dmesg | grep -i ipv6" which should give:
## "Ipv6: Loaded, but administratively disabled, ..."
##
##
class admin_ipv6 {
	
    include admin_ipv6::config

}
