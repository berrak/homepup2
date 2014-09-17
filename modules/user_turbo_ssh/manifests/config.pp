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
			
			file { 'asgard' :
				ensure => 'link',
				target => "/${name}/bin/ssh-to",
			}
			
			file { 'warp' :
				ensure => 'link',
				target => "/${name}/bin/ssh-to",
			}
			
			file { 'gondor' :
				ensure => 'link',
				target => "/${name}/bin/ssh-to",
			}
			
			file { 'hphome' :
				ensure => 'link',
				target => "/${name}/bin/ssh-to",
			}			
			
			file { 'rohan' :
				ensure => 'link',
				target => "/${name}/bin/ssh-to",
			}
			
			file { 'shire' :
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
			
			file { 'www' :
				ensure => 'link',
				target => "/${name}/bin/ssh-to",
			}
			
			file { 'dl380g7' :
				ensure => 'link',
				target => "/${name}/bin/ssh-to",
			}				
			
	   	}
		

	} else {
		
	    fail("FAIL: Unknown user ($name) for puppet on this host!")
		
	}
	

}
