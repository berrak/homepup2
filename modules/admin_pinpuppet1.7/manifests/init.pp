##
## This class set a predefined set of packages to a given priority level.
## This will pin this to a specified version defined in 'admin_pkgvers::params' 
##
class admin_pinpuppet1.7 {

    include admin_pinpuppet1.7::params

	# ensure that apt's /preferences.d directory exists
    
	file { "/etc/apt/preferences.d":
		ensure => "directory",
		owner => "root",
		group => "root",
	}
    
    define set_pinning ( $version, $priority ) {
    
        $file = "/etc/apt/preferences.d/$name"
        $package = $name

        file { $file:
            ensure  => present, 
        	owner   => 'root',
            group   => 'root',
            content => template("admin_pinpuppet1.7/preferences.d.erb"),
        }
    
    }
    

    # Puppet master runs both as server and agent
    
    if ( $::hostname == $::admin_pkgvers::params::mypuppetserver_hostname ) {
        
        set_pinning { 'puppet' :
            version => "$::admin_pkgvers::params::puppet_version",
            priority => "$::admin_pkgvers::params::pin_priority",
        }
        
        set_pinning { 'puppet-common':
            version => "$::admin_pkgvers::params::puppet_common_version",
            priority => "$::admin_pkgvers::params::pin_priority",
        }
        
        set_pinning { 'puppet-master' :
            version => "$::admin_pkgvers::params::puppetmaster_version",
            priority => "$::admin_pkgvers::params::pin_priority",
        }
        
        set_pinning { 'puppet-master-common' :
            version => "$::admin_pkgvers::params::puppetmaster_common_version",
            priority => "$::admin_pkgvers::params::pin_priority",
        }
        
    
    } else {
    
        set_pinning { 'puppet' :
            version => "$::admin_pkgvers::params::puppet_version",
            priority => "$::admin_pkgvers::params::pin_priority",
        }
        
        set_pinning { 'puppet-common' :
            version => "$::admin_pkgvers::params::puppet_common_version",
            priority => "$::admin_pkgvers::params::pin_priority",
        }
    }
    

    set_pinning { 'facter' :
        version => "$::admin_pkgvers::params::facter_version",
        priority => "$::admin_pkgvers::params::pin_priority",
    }
        
    set_pinning { 'ruby1.9.1' :
        version => "$::admin_pkgvers::params::rubylib_version",
        priority => "$::admin_pkgvers::params::pin_priority",
    }
    

}
