##
## The 'manage puppet agent' itself class
##
class puppet_agent::install {
  
    # Debian defaults to install puppet-common which
    # depends on facter - but just to show both.
  
    package { [ "puppet", "facter" ] :
        ensure => present,
    }
    
    # create a sub directory 'files' for Debian preseed files
	file { "/etc/puppet/files":
		ensure => directory,
		owner => 'root',
		group => 'root',
	}
    

}