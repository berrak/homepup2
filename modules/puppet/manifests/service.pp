##
## Puppet service.
##
class puppet::service {

    include puppet::params

	# For puppet server only
	
	if $::hostname == $::puppet::params::mypuppetserver_hostname {

        service { "puppetmaster":
            enable => true,
            hasrestart => true,
            ensure => running,
            require => Class["puppet::install"],
        }
    
    } 
    
    # reload puppet agent configuration but ensure its not running
    
    service { "restart_puppet_agent":
              name => "puppet",
            enable => false,
        hasrestart => true,
            ensure => restart,
    }
    
    service { "stop_puppet_agent":
              name => "puppet",
            enable => false,
        hasrestart => true,
            ensure => stopped,
            require => Service["restart_puppet_agent"],
    }
    
}