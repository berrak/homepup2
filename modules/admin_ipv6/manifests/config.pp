##
## This class disable (or enable again) ipv6 in the kernel. After a system
## reboot confirm with "dmesg | grep -i ipv6" which should give:
## "Ipv6: Loaded, but administratively disabled, ..."
##
## Sample use:
##    class { admin_ipv6::config : ensure => 'absent' }
##
class admin_ipv6::config ( $ensure='' ) {
	
	if ! ( $ensure in [ "present", "absent" ] ) {
	
		fail("FAIL: Use enable or absent as parameter to manage ipv6 in kernel-")
	
	}

    # set GRUB_CMDLINE_LINUX
	if $ensure == 'present' {
		$grubcmdline =''
	} elsif $ensure == 'absent' {
		$grubcmdline = 'ipv6.disable=1'	
	} else {
		fail("Ensure parameter ($ensure) unknown.")
	}
    
	exec { "updategrub" :
		command => "/usr/sbin/update-grub",
		refreshonly => true,
    }

	file { "/etc/default/grub":
		content => template( "admin_ipv6/grub.erb" ),
		owner => 'root',
		group => 'root',
		notify => [ Exec["updategrub"], Notify["ipv6_reboot_msg"] ],
	}
	
	notify {"ipv6_reboot_msg":
		message => "PUPPET IPv6 DISABLE: PLEASE REBOOT SYSTEM MANUALLY TO TAKE EFFECT",
    {

}
