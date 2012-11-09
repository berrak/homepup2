##
## Puppet service.
##
class puppetize::service {

    include puppetize::params

	# For puppet server only
	
	if $::hostname == $::puppetize::params::mypuppetserver_hostname {

        service { "puppetmaster":
            enable => true,
            hasrestart => true,
            ensure => running,
            require => Class["puppetize::install"],
        }
    
    } 
    
    # reloads puppet agent. Debian default (/etc/default/puppet) ensure
    # its not running. If this is not want's wanted change that file.
    
    service { "reload_puppet_agent":
              name => "puppet",
            enable => false,
        hasrestart => true,
            ensure => stopped,
		   require => Class["puppetize::install"],
    }
    
}