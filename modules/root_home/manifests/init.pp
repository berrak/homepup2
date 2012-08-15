##
## This class set up the /root/bin subdirectory and permissions
##
class admin_home {

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
	
}
