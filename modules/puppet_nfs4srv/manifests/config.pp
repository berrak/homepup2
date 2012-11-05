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

    $myexport0 = $::puppet_nfs4srv::params::export0

    file { '/etc/exports':
        content =>  template( 'puppet_nfs4srv/exports.erb' ),  
          owner => 'root',
          group => 'root',
    }
	
	$mydomain = $::hostname
	
    file { '/etc/idmapd.conf':
        content =>  template( 'puppet_nfs4srv/idmapd.conf.erb' ),  
          owner => 'root',
          group => 'root',
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
         mode => '0755',
	}
	
	# and (only on the server) link the local user directory 'nfs-$user' to this mnt-point
	
    file { "/home/${user}/nfs-${user}":
		ensure => link,
		target => "/mnt/exports/nfs-${user}",
		 owner => $user,
		 group => $user,
	}
	
	# nfs-common configuration - note: pure NFSv4 doesn't need legacy NFSv3 daemons
	
    file { '/etc/default/nfs-common':
         source =>  "puppet:///modules/puppet_nfs4srv/nfs-common",  
          owner => 'root',
          group => 'root',
    }
	
	# nfs-kernel-server configuration - note: pure NFSv4 doesn't need legacy NFSv3 daemons

    file { '/etc/default/nfs-kernel-server':
         source =>  "puppet:///modules/puppet_nfs4srv/nfs-kernel-server",  
          owner => 'root',
          group => 'root',
    }

}