##
## This class configure and set up the tripwire policy.
##
class puppet_tripwire::config {


	# directory for tripwire 'default' text configuration files
	# these are the file which is managed by puppet. When changing
	# policy and/or configuration please run the scripts
	# 'tripwire.updateconfiguration' and/or 'tripwire.updatepolicy'
	
	file { "/usr/local/etc/tripwire":
		ensure => "directory",
		owner => 'root',
		group => 'staff',
		mode => '0750',
	}
	
    # facter facts
	
	$mydomain = $::domain

	file { "/usr/local/etc/tripwire/twpol.txt" :
        content =>  template( 'puppet_tripwire/twpol.txt.erb' ),
		  owner => 'root',
		  group => 'root',
		   mode => '0600',
		require => File["/usr/local/etc/tripwire"],
	}

	file { "/usr/local/etc/tripwire/twcfg.txt" :
        content =>  template( 'puppet_tripwire/twcfg.txt.erb' ),
		  owner => 'root',
		  group => 'root',
		   mode => '0600',
		require => Package["/usr/local/etc/tripwire"],
	}


}
