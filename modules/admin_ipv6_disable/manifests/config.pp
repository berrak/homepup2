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

	file { "/etc/default/grub":
		content => template( "admin_ipv6_disable/grub.erb" ),
		owner => 'root',
		group => 'root',
	}

	exec { "updategrub" :
		command => "/usr/sbin/update-grub",
		 onlyif => "/bin/ls /proc/net/net | /bin/grep ipv6", 
	}
	
}
