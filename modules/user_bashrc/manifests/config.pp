##
## This define customize desktop users's .bashrc
##
## Sample usage:
##		user_bashrc::config { 'bekr' : }
##
define user_bashrc::config inherits admin_utils::append_if_no_such_line {
    
	
    # array of real users...(not root, or system accounts)
		
    if ( $name in ["bekr"] ) {
		
        # ensure that a local .bashrc sub directory for our snippets exist 
    
        file { "/home/${name}/.bashrc.d":
		    ensure => "directory",
		     owner => "${name}",
		     group => "${name}",
	    }		


		# Copy the .bashrc file to ~ directory
		file { "/home/${name}/.bashrc":
			source => "puppet:///modules/user_bashrc/bashrc",
			 owner => "${name}",
			 group => "${name}",
			  mode => '0644',
		}
		
		# Now append one line to .bashrc to source user customization file.
		# Note: this must follow above resource to make the append line persistent.
		admin_utils::append_if_no_such_line { "enable_${name}_customization" :
				
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
	
	    exec { "reloadlocaluserbashrc":
			command => "/bin/sh . /home/${name}/.bashrc",
	      subscribe => File["/home/${name}/.bashrc.d/${name}"],
	    refreshonly => true,
		}
	
	} else {
		
	    fail("Unknown user ($name) on this host!")
		
	}
	

}
