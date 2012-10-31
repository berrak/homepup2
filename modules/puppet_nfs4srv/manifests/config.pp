##
## Manage NFSv4 server
##
## Usage:
##     class { puppet_nfs4srv: user => 'bekr' }
##
class puppet_nfs4srv::config ( $user ='' ) {

    include puppet_nfs4srv::params

    if $user == '' {
    
        fail("FAIL: Missing the user ($user) parameter")
    }

    $myexport1 = $::puppet_nfs4::params::export1

    file { '/etc/exports':
        content =>  template( 'puppet_nfs4srv/exports.erb' ),  
          owner => 'root',
          group => 'root',
        require => Class["puppet_nfs4srv::install"],
    }
    
    # create the export directory for $user
    
	file { "/mnt/shireraid/nfs-${user}":
		ensure => "directory",
		 owner => $user,
		 group => $user,
         mode => '0640',
	}
    

}