##
## This class set a predefined set of packages to a given priority level. This
## will pin this to a specified version defined in 'admin_pinpuppet2_7::params' 
##
class admin_pinpuppet2_7 {

    include admin_pinpuppet2_7::params

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
            content => template("admin_pinpuppet2_7/preferences.d.erb"),
        }
    
    }
    

    # Puppet master runs both as server and agent
    
    if ( $::hostname == $::admin_pinpuppet2_7::params::mypuppetserver_hostname ) {
        
        set_pinning { 'puppet' :
            version => "$::admin_pinpuppet2_7::params::puppet_version",
            priority => "$::admin_pinpuppet2_7::params::pin_priority",
        }
        
        set_pinning { 'puppet-common':
            version => "$::admin_pinpuppet2_7::params::puppet_common_version",
            priority => "$::admin_pinpuppet2_7::params::pin_priority",
        }
        
        set_pinning { 'puppet-master' :
            version => "$::admin_pinpuppet2_7::params::puppetmaster_version",
            priority => "$::admin_pinpuppet2_7::params::pin_priority",
        }
        
        set_pinning { 'puppet-master-common' :
            version => "$::admin_pinpuppet2_7::params::puppetmaster_common_version",
            priority => "$::admin_pinpuppet2_7::params::pin_priority",
        }
        
    
    } else {
    
        set_pinning { 'puppet' :
            version => "$::admin_pinpuppet2_7::params::puppet_version",
            priority => "$::admin_pinpuppet2_7::params::pin_priority",
        }
        
        set_pinning { 'puppet-common' :
            version => "$::admin_pinpuppet2_7::params::puppet_common_version",
            priority => "$::admin_pinpuppet2_7::params::pin_priority",
        }
    }
    

    set_pinning { 'facter' :
        version => "$::admin_pinpuppet2_7::params::facter_version",
        priority => "$::admin_pinpuppet2_7::params::pin_priority",
    }
    
	# can't use ruby1.9.1 as this cause apt to ignore (invalid 'extension')     
    set_pinning { 'ruby1-9-1' :
        version => "$::admin_pinpuppet2_7::params::rubylib_version",
        priority => "$::admin_pinpuppet2_7::params::pin_priority",
    }
    

}
