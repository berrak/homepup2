##
## This define customize desktop users's .bashrc
##
## Sample usage:
##		user_bashrc::config { 'bekr' : }
##
define user_bashrc::config {
    
	include puppet_utils
	
    # array of real users...(not root, or system accounts)
		
    if ( $name in ["bekr"] ) {
		
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
	
	    exec { "reloadlocaluserbashrc":
			command => "/bin/sh . /home/${name}/.bashrc",
	      subscribe => File["/home/${name}/.bashrc.d/${name}"],
	    refreshonly => true,
		}
	
	} else {
		
	    fail("Unknown user ($name) on this host!")
		
	}
	

}
