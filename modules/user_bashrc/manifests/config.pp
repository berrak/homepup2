##
## This define customize desktop users's .bashrc
##
## Sample usage:
##		user_bashrc::config { 'bekr' : }
##
define user_bashrc::config {
    
	
	## Note: Some files/directory creation is not relevant but is added
	## anyway, Not ideal but due to that the regular user (here 'bekr')
	## is also the systems 'admin' user (Todo: create different admin name)
	
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
		
	    file { "/home/${name}/pythonwork":
		    ensure => "directory",
		     owner => "${name}",
		     group => "${name}",
	    }	

        # User virtual box images (on a large data partition, /opt or /srv)
		
        file { "/opt/${name}":
		    ensure => "directory",
		     owner => "${name}",
		     group => "${name}",
	    }		

        file { "/opt/${name}/virtualbox":
		     ensure => "directory",
		      owner => "${name}",
		      group => "${name}",
			require => File["/opt/${name}"],
	    }
		
		file { "/opt/${name}/virtualbox/VirtualBox VMs":
		 ensure => "directory",
		  owner => "${name}",
		  group => "${name}",
		require => File["/opt/${name}/virtualbox"],
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
		
		# perl rc file, sourced at login
		
	    file { "/home/${name}/bashrc.d/perl.rc":
			source => "puppet:///modules/user_bashrc/perl.rc",
			 owner => "${name}",
			 group => "${name}",
			  mode => '0644',
		   require => File["/home/${name}/bashrc.d/${name}"],
	   	}
		
		# python rc file, sourced at login
		
		file { "/home/${name}/bashrc.d/python.rc":
			source => "puppet:///modules/user_bashrc/python.rc",
			 owner => "${name}",
			 group => "${name}",
			  mode => '0644',
		   require => File["/home/${name}/bashrc.d/${name}"],
	   	}
		

        # Required - for below fix, create main lxde config directory

		file { "/home/${name}/.config":
			ensure => "directory",
			 owner => "${name}",
			 group => "${name}",
		}
		
		# fix bug in lxterminal user can't make configuration
		# persistent (Debian sets defaults as root ownership).
		
		file { "/home/${name}/.config/lxterminal":
			 ensure => "directory",
			  owner => "${name}",
			  group => "${name}",
			   mode => '0755',
			require => File["/home/${name}/.config"],
		}
		
		# Fix bug only if display manager 'lightdm' exists (i.e. skip on servers)
		
		exec { "/home/${name}/.config/lxterminal/lxterminal.conf":
				 command => "/usr/bin/test -x /home/${name}/.config/lxterminal/lxterminal.conf && /bin/chown ${name}:${name} /home/${name}/.config/lxterminal/lxterminal.conf",
				  unless => "/bin/ps aux | /bin/grep lightdm",
				 require => File["/home/${name}/.config/lxterminal"],
		}
		
	
	} else {
		
	    fail("FAIL: Unknown user ($name) for puppet on this host!")
		
	}
	

}
