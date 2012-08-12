##
## This class set a predefined set of packages to a given priority level.
## This will pin this to a specified version defined in 'admin_pkgvers::params' 
##
## Sample usage: 
##       admin_pkgvers::aptpin { 'puppet_agentbndl' : pinning_priority => '1001' }
##       admin_pkgvers::aptpin { 'puppet_masterbndl' : pinning_priority => '1001' }
##       admin_pkgvers::aptpin { 'puppet_facter' : pinning_priority => '1001' }
##       admin_pkgvers::aptpin { 'puppet_rubylib' : pinning_priority => '1001' }
##
define admin_pkgvers::aptpin ( $pinning_priority ){

    include admin_pkgvers::params
	
    $priority = $pinning_priority
	
    case $name {
			
        puppet_masterbndl : {
        
		    $file = "/etc/apt/preferences.d/puppetmaster"
            $package = 'puppetmaster'
		    $version = $::admin_pkgvers::params::puppetmaster_version
			
		    file { $file:
                ensure  => present, 
        	    owner   => 'root',
                group   => 'root',
                content => template("admin_pkgvers/preferences.d.erb"),
		    }
			
		    $file = "/etc/apt/preferences.d/puppetmaster-common"
		    $package = 'puppetmaster-common'
		    $version = $::admin_pkgvers::params::puppetmaster_common_version
			
		    file { $file:
				ensure  => present, 
				owner   => 'root',
				group   => 'root',
				content => template("admin_pkgvers/preferences.d.erb"),
		    }		
        
        }

        puppet_agentbndl : {
	
		    $file = "/etc/apt/preferences.d/puppet"
            $package = 'puppet'
		    $version = $::admin_pkgvers::params::puppet_version
			
		    file { $file:
                ensure  => present, 
        	    owner   => 'root',
                group   => 'root',
                content => template("admin_pkgvers/preferences.d.erb"),
		    }
			
			
		    $file = "/etc/apt/preferences.d/puppet-common"
		    $package = 'puppet-master-common'
		    $version = $::admin_pkgvers::params::puppet_common_version
			
		    file { $file:
				ensure  => present, 
				owner   => 'root',
				group   => 'root',
				content => template("admin_pkgvers/preferences.d.erb"),
		    }			
		
		}
		
        puppet_facter : {
	
		    $file = "/etc/apt/preferences.d/facter"
            $package = 'facter'
		    $version = $::admin_pkgvers::params::facter_version
			
		    file { $file:
                ensure  => present, 
        	    owner   => 'root',
                group   => 'root',
                content => template("admin_pkgvers/preferences.d.erb"),
		    }		
		
		}
		

        puppet_rubylib : {
	
		    $file = "/etc/apt/preferences.d/ruby"
            $package = 'ruby'
		    $version = $::admin_pkgvers::params::rubylib_version
			
		    file { $file:
                ensure  => present, 
        	    owner   => 'root',
                group   => 'root',
                content => template("admin_pkgvers/preferences.d.erb"),
		    }		
		
		}

    
	    default : {
		
		    fail("Unknown definition ($name) of apt pinning bundle")
		}
	
    }

}