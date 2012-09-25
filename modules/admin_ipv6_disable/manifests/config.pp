##
## This class disable ipv6 in the kernel. After a reboot
## confirm with "dmesg | grep -i ipv6" which should give:
## "Ipv6: Loaded, but administratively disabled, ..."
## or:
## "ls -l /proc/sys/net | grep ipv6"
##
class admin_ipv6_disable::config {

    include admin_ipv6_disable::params

    $grubcmdline = $::admin_ipv6_disable::params::mygrubcmdline
	
	if ( $::hostname == $::admin_ipv6_disable::params::myvgahost ) {
	    $grubdefault = $::admin_ipv6_disable::params::myvgaline
	} else {
	    $grubdefault = 'quiet'
	}

	if ( $::is_ipv6host == 'true' ) {

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
		
    } else {
	
		notify { "ipv6_status": message => "System still support ipv6" }
	
	}
	
}
