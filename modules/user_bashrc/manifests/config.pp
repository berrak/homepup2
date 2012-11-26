##
## This define customize desktop users's .bashrc
##
## Sample usage:
##		user_bashrc::config { 'bekr' : }
##
define user_bashrc::config {
    
	include puppet_utils
	
    # array of real users...(not root, or system accounts)
		
    if ( $name in ["bekr", "dakr"] ) {
		
		# create a bin sub directory for the user
		
        file { "/home/${name}/bin":
		    ensure => "directory",
		     owner => "${name}",
		     group => "${name}",
	    }		
		
        # ensure that a local .bashrc sub directory for our snippets exist 
    
        file { "/home/${name}/.bashrc.d":
		    ensure => "directory",
		     owner => "${name}",
		     group => "${name}",
	    }		
		
		# Now append one line to original .bashrc to source user customizations.
		
		puppet_utils::append_if_no_such_line { "enable_${name}_customization" :
				
		    file => "/home/${name}/.bashrc",
		    line => "[ -f ~/.bashrc.d/${name} ] && source ~/.bashrc.d/${name}" 
		
		}
	
	    # add the actual customization file to the .bashrc.d snippet directory
		
	    file { "/home/${name}/.bashrc.d/${name}":
			source => "puppet:///modules/user_bashrc/${name}",
			 owner => "${name}",
			 group => "${name}",
			  mode => '0644',
		   require => File["/home/${name}/.bashrc.d"],
	   	}
	
		# if the local customization file is changed, source .bashrc again
	
	    exec { "reloadlocaluserbashrc.${name}":
			command => "/bin/sh . /home/${name}/.bashrc",
	      subscribe => File["/home/${name}/.bashrc.d/${name}"],
	    refreshonly => true,
		}
		
		# manage the .profile file for each user (automatic backup at login)
		
	    file { "/home/${name}/.profile":
			source => "puppet:///modules/user_bashrc/profile",
			 owner => "${name}",
			 group => "${name}",
			  mode => '0644',
		   require => File["/home/${name}"],
	   	}	
	
	} else {
		
	    fail("FAIL: Unknown user ($name) for puppet on this host!")
		
	}
	

}
