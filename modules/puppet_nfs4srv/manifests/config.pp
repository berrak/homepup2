##
## Manage NFSv4 server
##
## Usage:
##     class { puppet_nfs4srv: user => 'bekr' }
##
class puppet_nfs4srv::config ( $user ='' ) {

    include puppet_nfs4srv::params
	include puppet_nfs4srv::install
	include puppet_nfs4srv::service

    if $user == '' {
    
        fail("FAIL: Missing the user ($user) parameter")
    }

    $myexport0 = $::puppet_nfs4srv::params::export0

    file { '/etc/exports':
        content =>  template( 'puppet_nfs4srv/exports.erb' ),  
          owner => 'root',
          group => 'root',
    }
	
	# if 'exports' is updated, refresh nfs server
	
	exec { "reload_NFSv4_exports":
		command => '/usr/sbin/exportfs -ra',
		subscribe => File["/etc/exports"],
		refreshonly => true,
	}
    
    # create local $user directory (will mirror this to $user exports nfs directory)
    
	file { "/home/$user/nfs":
		ensure => "directory",
		 owner => $user,
		 group => $user,
         mode => '0750',
	}	
	
    # create the 'root' directory of all exports
	
	file { "/exports/nfs":
		 ensure => "directory",
		  owner => 'root',
		  group => 'root',
	}
	
	
    # create the exports directory for internal nfs $user
	
	file { "/exports/nfs/$user":
		 ensure => "directory",
		  owner => $user,
		  group => $user,
           mode => '0755',
		require => File["/exports/nfs],
	}

    # the UID/GID mapping daemon configuration

	$mydomain = $::domain
	
    file { '/etc/idmapd.conf':
        content =>  template( 'puppet_nfs4srv/idmapd.conf.erb' ),  
          owner => 'root',
          group => 'root',
		 notify => Class["puppet_nfs4srv::service"],
    }	

	# nfs-common configuration - note: pure NFSv4 doesn't need legacy NFSv3 daemons
	
    file { '/etc/default/nfs-common':
        source =>  "puppet:///modules/puppet_nfs4srv/nfs-common",  
         owner => 'root',
         group => 'root',
		notify => Class["puppet_nfs4srv::service"],
    }
	
	# nfs-kernel-server configuration - note: pure NFSv4 doesn't need legacy NFSv3 daemons

    file { '/etc/default/nfs-kernel-server':
        source =>  "puppet:///modules/puppet_nfs4srv/nfs-kernel-server",  
         owner => 'root',
         group => 'root',
		notify => Class["puppet_nfs4srv::service"],
    }

}