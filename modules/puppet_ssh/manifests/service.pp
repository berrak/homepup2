##
## puppet_ssh manage openssh server and clients.
##
class puppet_ssh::service {
    
    if $::hostname in [ 'valhall', 'warp' ] {
	
		service { "ssh":
			
				ensure => running,
			 hasstatus => true,
			hasrestart => true,
				enable => true,
			   require => Package["openssh-server"],
	
		}
	
	}

}