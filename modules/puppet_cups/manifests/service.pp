##
## This class starts the service cups.
##
class puppet_cups::service {

	service { "cups":
		
		    ensure => running,
		 hasstatus => true,
		hasrestart => true,
		    enable => true,
		   require => Package["cups"],

	}

}
