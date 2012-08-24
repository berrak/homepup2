##
## This class set up the /root/bin subdirectory and permissions
##
class root_home {

	# set /root directory only for root's eyes
	file { "/root":
		owner => 'root',
		group => 'root',
		mode => '0700',
	}	
	
	# /root files only rw
	exec { "setrootownership":
		command => "/bin/chmod 0600 /root/*",
		subscribe => File["/root"],
		refreshonly => true,
	}

	# create a bin subdirectory directory only for root's binary tools
	file { "/root/bin":
		ensure => "directory",
		owner => 'root',
		group => 'root',
		mode => '0700',
	}
	
	# set up a mount point for usb flash memory on /media/usb
	
    file { "/media/usb0":
		ensure => "directory",
		owner => 'root',
		group => 'root',
	}

	file { "/media/usb":
		ensure => link,
		target => "/media/usb0",
	}
	
}
