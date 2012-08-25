##
## This class disable (or enable again) ipv6 in the kernel. After a system
## reboot confirm with "dmesg | grep -i ipv6" which should give:
## "Ipv6: Loaded, but administratively disabled, ..."
## or 'ls -l /proc/sys/net | grep ipv6'
##
##
class admin_ipv6_disable::config {

    $grubcmdline = 'ipv6.disable=1'	

	if ( $::is_ipv6host == 'true') {

		notify { "ipv6_reboot_msg":
		message => "PUPPET IPv6 DISABLE: Reboot system to make changes active. Test with: dmesg | grep -i ipv6",
		}

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
		
    }
	
}
