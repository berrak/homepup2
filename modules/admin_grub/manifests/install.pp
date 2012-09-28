##
## This defines a string to grub parameter GRUB_CMDLINE_LINUX_DEFAULT and
## use GRUB_CMDLINE_LINUX to disable ipv6 in the kernel. If kernel have
## disabled ipv6 type: ls /proc/sys/net
##
## Usage:
##          class { admin_grub::install :
##                          defaultline => 'vga=791',
##                           appendline => 'true',
##                                 ipv6 => 'false',
##          }
##
class admin_grub::install (
							$defaultline = 'quiet',
							$appendline = 'false',
							$ipv6 = 'false',
) {

	case $appendline {
	
	    'true': {
		    $grubdefault = "quiet $defaultline"
		}
		
		'false': {
		    $grubdefault = $defaultline
		}
	
	    default: {
		    fail("FAIL: Unknown parameter 'appendline' ($appendline), use either 'false' or 'true'")
		}
	}
	
	case $ipv6 {
	
	    'true': {
		    $grubcmdline = ''
		}
		
		'false': {
		    $grubcmdline = 'ipv6.disable=1'
		}
	
	    default: {
		    fail("FAIL: Unknown parameter 'ipv6' ($ipv6), use either 'false' or 'true'")
		}
	
	}
	
	file { "/etc/default/grub":
		content => template( "admin_grub/grub.erb" ),
		  owner => 'root',
		  group => 'root',	  
		 notify => Exec["GRUB_CONFIGURATION_CHANGED_PLEASE_REBOOT_TO_APPLY_CHANGES"],
	}

	exec { "GRUB_CONFIGURATION_CHANGED_PLEASE_REBOOT_TO_APPLY_CHANGES" :
		    command => "/usr/sbin/update-grub",
		refreshonly => true,
	}
	
}
