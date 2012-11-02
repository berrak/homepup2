##
## Manage NFSv4 server
##
## Usage:
##     class { puppet_nfs4srv: user => 'bekr' }
##
class puppet_nfs4srv::config ( $user ='' ) {

    include puppet_nfs4srv::params
	include puppet_nfs4srv::install

    if $user == '' {
    
        fail("FAIL: Missing the user ($user) parameter")
    }

    $myexport1 = $::puppet_nfs4srv::params::export1

    file { '/etc/exports':
        content =>  template( 'puppet_nfs4srv/exports.erb' ),  
          owner => 'root',
          group => 'root',
        require => Class["puppet_nfs4srv::install"],
    }
	
	# if 'exports' is updated, refresh nfs server
	
	exec { "reload_NFSv4_exports":
		command => '/usr/sbin/exportfs -ra',
		subscribe => File["/etc/exports"],
		refreshonly => true,
	}
    
    # finally, create the export directory for $user
    
	file { "/mnt/exports/nfs-${user}":
		ensure => "directory",
		 owner => $user,
		 group => $user,
         mode => '0640',
	}
    

}