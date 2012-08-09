##
## This class starts the networking service.
##
class puppet_network::service {

	service { "networking":
		
		    ensure => running,
		 hasstatus => true,
		hasrestart => true,
		    enable => true,
		   require => File["/etc/network/interfaces"],

	}

}
