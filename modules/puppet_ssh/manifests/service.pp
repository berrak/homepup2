##
## puppet_ssh manage openssh server and clients.
##
class puppet_ssh::service {

    include puppet_ssh::params
    
    if $::hostname == $::puppet_ssh::params::sshserverhostname {

		service { "ssh":
			
				ensure => running,
			 hasstatus => true,
			hasrestart => true,
				enable => true,
			   require => Package["openssh-server"],
	
		}
	
	}

}