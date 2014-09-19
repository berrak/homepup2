##
## Super fast ssh login to remote hosts
##
## Sample usage:
##		user_turbo_ssh::config { 'bekr' : }
##
define user_turbo_ssh::config {
    
    # array of real users...(not root, or system accounts)
		
    if ( $name in ["root", "bekr"] ) {
		
		## script 'ssh-to' and symbolic links for local root managed servers
		
		if $name == 'root' {
		
		    file { "/${name}/bin/ssh-to":
				source => "puppet:///modules/user_turbo_ssh/${name}.ssh-to",
				 owner => "${name}",
				 group => "${name}",
				  mode => '0700',
			}
			
			# Internal LAN hosts allow ssh out as user root
			
			file { "/${name}/bin/asgard" :
				ensure => 'link',
				target => "/${name}/bin/ssh-to",
			}
			
			file { "/${name}/bin/warp" :
				ensure => 'link',
				target => "/${name}/bin/ssh-to",
			}
			
			file { "/${name}/bin/gondor" :
				ensure => 'link',
				target => "/${name}/bin/ssh-to",
			}
			
			file { "/${name}/bin/rohan" :
				ensure => 'link',
				target => "/${name}/bin/ssh-to",
			}
			
			file { "/${name}/bin/shire" :
				ensure => 'link',
				target => "/${name}/bin/ssh-to",
			}
			
			# laptops
			
			file { "/${name}/bin/mordor" :
				ensure => 'link',
				target => "/${name}/bin/ssh-to",
			}
			
			file { "/${name}/bin/dell" :
				ensure => 'link',
				target => "/${name}/bin/ssh-to",
			}		
			
			
	   	}
		else {
		
		    file { "/home/${name}/bin/ssh-to":
				source => "puppet:///modules/user_turbo_ssh/${name}.ssh-to",
				 owner => "${name}",
				 group => "${name}",
				  mode => '0750',
			}
			
			# (semi)public hosts only allow ssh out from regular user
			
			file { "/home/${name}/bin/www" :
				ensure => 'link',
				target => "/home/${name}/bin/ssh-to",
			}
			
			file { "/home/${name}/bin/dl380g7" :
				ensure => 'link',
				target => "/home/${name}/bin/ssh-to",
			}
			
			file { "/home/${name}/bin/hphome" :
				ensure => 'link',
				target => "/${name}/bin/ssh-to",
			}			
			
	   	}
		

	} else {
		
	    fail("FAIL: Unknown user ($name) for puppet on this host!")
		
	}
	

}
