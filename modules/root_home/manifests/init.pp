##
## This class set up the /root subdirectories and permissions, incl 
## mails (postfix/mutt etc) although not recommended to read mail as root.
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
	
	# set up Maildir structure for root
	
	file { "/root/Maildir":
		ensure => "directory",
		 owner => 'root',
		 group => 'root',
		  mode => '0700',
	}
	
    file { "/root/Maildir/.Sent":
		 ensure => "directory",
		  owner => 'root',
		  group => 'root',
		   mode => '0700',
		require => File["/root/Maildir"],
	}
	
    file { "/root/Maildir/.Drafts":
		 ensure => "directory",
		  owner => 'root',
	 	  group => 'root',
		   mode => '0700',
		require => File["/root/Maildir"],
	}	
	
    exec { "make_root_maildirs_drafts":
		command => "/bin/mkdir /root/Maildir/.Drafts/{new,cur,tmp}",
		subscribe => File["/root/Maildir/.Drafts"],
		refreshonly => true,
	}
	
    exec { "make_root_maildirs_sent":
		command => "/bin/mkdir /root/Maildir/.Sent/{new,cur,tmp}",
		subscribe => File["/root/Maildir/.Sent"],
		refreshonly => true,
	}
	
	
	
}
