##
## This define customize desktop users's .bashrc
##
## Sample usage:
##		user_bashrc::config { 'bekr' : }
##
define user_bashrc::config {
    
	include puppet_utils	

    # array of real users...(not root, or system accounts)
		
    if ( $name in ["bekr", "dakr", "levonline"] ) {
		
		# create a couple of standard sub directories for the user
		
        file { "/home/${name}/bin":
		    ensure => "directory",
		     owner => "${name}",
		     group => "${name}",
	    }		
		
        file { "/home/${name}/tmp":
		    ensure => "directory",
		     owner => "${name}",
		     group => "${name}",
	    }		
	
        file { "/home/${name}/bashwork":
		    ensure => "directory",
		     owner => "${name}",
		     group => "${name}",
	    }			

        file { "/home/${name}/perlwork":
		    ensure => "directory",
		     owner => "${name}",
		     group => "${name}",
	    }			

        # User virtual box images (on a large data partition)
		
        file { "/srv/${name}-virtualbox-vms":
		    ensure => "directory",
		     owner => "${name}",
		     group => "${name}",
	    }		

		
		## default backup (rsync) configuration. Contains rsync password.
		
	    file { "/home/${name}/bin/${name}.backup":
			source => "puppet:///modules/user_bashrc/${name}.backup",
			 owner => "${name}",
			 group => "${name}",
			  mode => '0600',
		   require => File["/home/${name}/bin"],
	   	}	
		
        # ensure that a local .bashrc sub directory for our snippets exist 
    
        file { "/home/${name}/bashrc.d":
		    ensure => "directory",
		     owner => "${name}",
		     group => "${name}",
	    }		
		
		# Now append one line to original .bashrc to source user customizations.
		
		puppet_utils::append_if_no_such_line { "enable_${name}_customization" :
				
		    file => "/home/${name}/.bashrc",
		    line => "[ -f ~/bashrc.d/${name} ] && source ~/bashrc.d/${name}" 
		
		}
	
	    # add the actual 'user' customization file to the .bashrc.d snippet directory
		
	    file { "/home/${name}/bashrc.d/${name}":
			source => "puppet:///modules/user_bashrc/${name}",
			 owner => "${name}",
			 group => "${name}",
			  mode => '0644',
		   require => File["/home/${name}/bashrc.d"],
	   	}
	
		# if the local customization file is changed, source .bashrc again
	
	    exec { "reloadlocaluserbashrc.${name}":
			command => "/bin/sh . /home/${name}/.bashrc",
	      subscribe => File["/home/${name}/bashrc.d/${name}"],
	    refreshonly => true,
		}
		
		# perl snippet file, sourced at login
		
	    file { "/home/${name}/bashrc.d/perl.rc":
			source => "puppet:///modules/user_bashrc/perl.rc",
			 owner => "${name}",
			 group => "${name}",
			  mode => '0644',
		   require => File["/home/${name}/bashrc.d/${name}"],
	   	}
		
		# fix bug in lxterminal - useer can't make configuration
		# persistent (installed configuration set as root ownership)
		
        file { "/home/${name}/.config/lxterminal":
		    ensure => "directory",
		     owner => "${name}",
		     group => "${name}",
			  mode => '0755',
	    }
			
		exec { "/home/${name}/.config/lxterminal/lxterminal.conf":
			    command => "/bin/chown ${name}:${name} /home/${name}/.config/lxterminal/lxterminal.conf",
			  subscribe => File["/home/${name}/.config/lxterminal"],
	        refreshonly => true,
		}
	
	} else {
		
	    fail("FAIL: Unknown user ($name) for puppet on this host!")
		
	}
	

}
