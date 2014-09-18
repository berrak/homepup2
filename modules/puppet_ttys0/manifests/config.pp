##
##  Configure the first serial port ttyS0
##
class puppet_ttys0::config {
 
    # enable the first serial port
    
	file { "/etc/inittab":
		source => "puppet:///modules/puppet_ttys0/inittab",
		 owner => 'root',
		 group => 'root',
		  mode => '0644',
    }
    
    # if inittab is updated, initilize system again

    exec { "reload_inittab":
        command => "/bin/bash init q",
      subscribe => File["/etc/inittab"],
    refreshonly => true,
    }
	
}