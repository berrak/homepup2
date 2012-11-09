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
    
    # reload puppet agent. Debian default (/etc/default/puppet)
    # ensures its not running. If this is not required change that file.
    
    service { "reload_puppet_agent":
              name => "puppet",
            enable => false,
        hasrestart => true,
            ensure => restart,
    }
    
}