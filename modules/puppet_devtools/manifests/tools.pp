##
## This class manage puppet developer wrappers and
## defaults to a wrapper path as defined in params.pp
##
## Usage in node for e.g. user 'bekr':
##
##			puppet_devtools::tools { 'bekr' : }
##
define puppet_devtools::tools {

    # TODO: test for valid user names
	
	include puppet_devtools::params
	
    # Create a default path for puppet development i.e. when a new 
	# module is named, sub directories are created in this location
	$moduledirectory = "/home/${name}/$::puppet_devtools::params::usermodulepath"
	
	file { '/usr/local/bin/puppet.newmodule' :
		content =>  template( 'puppet_devtools/puppet.newmodule.erb' ),
		  owner => 'root',
		  group => 'staff',
		   mode => '0555',
	}
	
	# Validate manifest and erb templates syntax wrapper
	
	file { "/usr/local/bin/puppet.syntax":
		source => "puppet:///modules/puppet_devtools/puppet.syntax",
		 owner => 'root',
		 group => 'staff',
		  mode => '0555',
    }
		
		
}
