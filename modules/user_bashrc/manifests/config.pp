##
## This define customize desktop users's .bashrc
##
## Sample usage:
##		user_bashrc::config { 'bekr' : }
##
define user_bashrc::config {
    
		# array of real users...(not root, or system accounts)
		
        if ( $name in ["bekr"] ) {

		    file { "/home/${name}/.bashrc":
				source => "puppet:///modules/user_bashrc/user_bashrc",
				 owner => "${name}",
				 group => "${name}",
				  mode => '0644',
		    }
	
		    file { "/home/${name}/.bashrc_user":
				source => "puppet:///modules/user_bashrc/${name}_bashrc",
				 owner => "${name}",
				 group => "${name}",
				  mode => '0644',
			   require => File["/home/${name}/.bashrc"],
		   	}
	
		# if one or both of these files are created/changed, source .bashrc
		    exec { "reloaduserbashrc":
				command => "/bin/sh . /home/${name}/.bashrc",
			  subscribe => File["/home/${name}/.bashrc"],
			refreshonly => true,
			}
	
		    exec { "reloadlocaluserbashrc":
				command => "/bin/sh . /home/${name}/.bashrc",
		      subscribe => File["/home/${name}/.bashrc_user"],
		    refreshonly => true,
			}
	
		} else {
		
		    fail("Unknown user ($name) on this host!")
		
		}
	

}
