##
## Manage Puppet
##
class puppet::install {
  
    include puppet::params
  
    # Debian defaults to install puppet-common which
    # depends on facter - but just to show both.
  
  	# Install puppet agent regardless if this is the puppet server or agent
  
    package { [ "puppet", "facter" ] :
        ensure => present,
    }
	
	# install some utilities
	
	file { "/root/bin/puppet.exec":
		source => "puppet:///modules/puppet/puppet.exec",
		 owner => 'root',
		 group => 'root',
		  mode => '0700',
	}
	
	file { "/root/bin/puppet.simulate":
		source => "puppet:///modules/puppet/puppet.simulate",
		 owner => 'root',
		 group => 'root',
		  mode => '0700',
	}
	
  
	# For puppet server
	
	if $::hostname == $::puppet::params::mypuppetserver_hostname {
	
        package { "puppetmaster" :
            ensure => present,
			notify => Class["puppet::service],
		}
		
        # create a sub directory 'files' for Debian preseed files
		
        file { "/etc/puppet/files":
            ensure => directory,
             owner => 'root',
             group => 'root',
        }
		
	}

}