##
## This class disable (or enable again) ipv6 in the kernel. After a system
## reboot confirm with "dmesg | grep -i ipv6" which should give:
## "Ipv6: Loaded, but administratively disabled, ..."
##
##
class admin_ipv6_disable::config {

    $grubcmdline = 'ipv6.disable=1'	

	notify {"ipv6_reboot_msg":
		message => "PUPPET IPv6 DISABLE: PLEASE REBOOT SYSTEM MANUALLY TO TAKE EFFECT",
		subscribe => File["/etc/default/grub"],
    }

	exec { "updategrub" :
		command => "/usr/sbin/update-grub",
		refreshonly => true,
    }

	file { "/etc/default/grub":
		content => template( "admin_ipv6_disable/grub.erb" ),
		owner => 'root',
		group => 'root',
		notify => [ Exec["updategrub"], Notify["ipv6_reboot_msg"] ],
	}

}
