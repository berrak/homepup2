##
## This class disable (or enable again) ipv6 in the kernel. After a system
## reboot confirm with "dmesg | grep -i ipv6" which should give:
## "Ipv6: Loaded, but administratively disabled, ..."
##
##
class admin_ipv6_disable::config {

    $grubcmdline = 'ipv6.disable=1'	

	exec { "updategrub" :
		command => "/usr/sbin/update-grub",
		refreshonly => true,
    }

	file { "/etc/default/grub":
		content => template( "admin_ipv6_disable/grub.erb" ),
		owner => 'root',
		group => 'root',
		notify => Exec["updategrub"],
	}
	
	notify {"$::ipaddress4enabled":}
	if ( $::ipaddress4enabled == 'ipv4') {
	
		notify {"Here we get ipv4 as test ($::ipaddress4enabled)":}
	
	}
	
#    notify {"ipv6_reboot_msg":
#		message => "PUPPET IPv6 DISABLE: REBOOT SYSTEM TO TAKE EFFECT. TEST WITH: dmesg | grep -i ipv6",
#    }

}
