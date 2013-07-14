##
## Configure first step in Komodo IDE 6 setup.
#3 To finish at each host, run the shell installer and the license
## executable.
##
## Sample use:
##
##     puppet_komodoide6::install { 'bekr' : hostarch => 'i386' }
##
define puppet_komodoide6::install ( $hostarch = '' ) {


    include puppet_komodoide6::params
	
    
    if ! ( $hostarch in [ 'i386', 'amd64' ]) {
	    fail("FAIL: The given host architecture must be either 'i386' or 'amd64' only.")
	}
	
    if ! ( $::architecture in [ 'i386', 'amd64' ]) {
	    fail("FAIL: System does not support architecture, must be either 'i386' or 'amd64' only.")
	}

	$mykomdopath = $::puppet_komodoide6::params::komodoide6_source_filepath

	file { "$mykomdopath":
		ensure => "directory",
		owner => 'root',
		group => 'root',
	}


    case $hostarch {

        'i386': {

			# The tar gz archieve of Komodo IDE 6.1
			file { "/home/${name}/tmp/${::puppet_komodoide6::params::targzfile_i386}" : 
				 source => "${mykomdopath}/${::puppet_komodoide6::params::targzfile_i386}",
				  owner => $name,
				  group => $name,
				require => File[$mykomdopath],
			}
	
			# The licence installer for Komodo IDE 6.1
			file { "/home/${name}/tmp/${::puppet_komodoide6::params::exec_i386}" : 
				 source => "${mykomdopath}/${::puppet_komodoide6::params::exec_i386}",
				  owner => $name,
				  group => $name,
				   mode => '0755',
				require => File[$mykomdopath],
			}

        
        }
        
        'amd64': {


			# The tar gz archieve of Komodo IDE 6.1
			file { "/home/${name}/tmp/${::puppet_komodoide6::params::targzfile_amd64}" : 
				 source => "${mykomdopath}/${::puppet_komodoide6::params::targzfile_amd64}",
				  owner => $name,
				  group => $name,
				require => File[$mykomdopath],
			}
	
			# The licence installer for Komodo IDE 6.1
			file { "/home/${name}/tmp/${::puppet_komodoide6::params::exec_amd64}" : 
				 source => "${mykomdopath}/${::puppet_komodoide6::params::exec_amd64}",
				  owner => $name,
				  group => $name,
				   mode => '0755',
				require => File[$mykomdopath],
			}

        
        }

        default: {
        
            fail("FAIL: System architecture does not match ($hostarch) given as parameter.")
        
        }
    
    }
    

	
    
}