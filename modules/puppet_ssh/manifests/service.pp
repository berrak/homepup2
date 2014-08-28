##
## puppet_ssh manage openssh server and clients.
##
class puppet_ssh::service {
    
	service { "ssh":
		
			ensure => running,
		 hasstatus => true,
		hasrestart => true,
			enable => true,
		   require => Package["openssh-server"],
	}
	
}