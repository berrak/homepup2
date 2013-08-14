#
# Class to configure pylint
#
define puppet_pylint::config {

    include puppet_pylint

    if $name == '' {
        fail("FAIL: No user ($name) given as argument.")
    }
    
    file { "/home/${name}/pylint":
        ensure => "directory",
         owner => "$name",
         group => "$name",
    }
    
	# Pylint configuration file
	
	file { "/home/${name}/pylint/pylintrc":
		 source => "puppet:///modules/puppet_pylint/pylintrc",
          owner => "$name",
          group => "$name",
		require => File["/home/${name}/pylint"],
	}
    
}