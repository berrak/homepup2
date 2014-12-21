##
## Manage NFSv4 server
##
## Usage:
##     class { puppet_nfs4srv: user => 'bekr' }
##
## Limitations: Only works single user (i.e. call this only once).
## Todo: Create define to process list of users.
##
class puppet_nfs4srv::config ( $user ='' ) {

    include puppet_nfs4srv::params
	include puppet_nfs4srv::install
	include puppet_nfs4srv::service

    if $user == '' {
    
        fail("FAIL: Missing the user ($user) parameter")
    }

    $myexport0 = $::puppet_nfs4srv::params::export0
	$myexport1 = $::puppet_nfs4srv::params::export1
	$myexport2 = $::puppet_nfs4srv::params::export2
	$myexport3 = $::puppet_nfs4srv::params::export3
	
	$rootexport1 = $::puppet_nfs4srv::params::rootexport1	

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
    
    # create local $user directory (will 'bind mount' content to $user exports nfs directory)
    
	file { "/home/$user/nfs":
		ensure => "directory",
		 owner => $user,
		 group => $user,
          mode => '0755',
	}	
	
    # create the 'root' directory of all exports
	
	file { "/exports/usernfs4":
		 ensure => "directory",
		  owner => 'root',
		  group => 'root',
	}
	
	
    # create the exports directory for internal nfs $user
	file { "/exports/usernfs4/$user":
		 ensure => "directory",
		  owner => $user,
		  group => $user,
           mode => '0755',
		require => File["/exports/usernfs4"],
	}

	# always create a root directory for /mnt export
	file { "/exports/usernfs4/root":
		 ensure => "directory",
		  owner => 'root',
		  group => 'root',
           mode => '0755',
		require => File["/exports/usernfs4"],
	}

    # the UID/GID mapping daemon configuration

	$mydomain = $::domain
	
    file { '/etc/idmapd.conf':
        content =>  template( 'puppet_nfs4srv/idmapd.conf.erb' ),  
          owner => 'root',
          group => 'root',
		 notify => Class["puppet_nfs4srv::service"],
    }	

	# nfs-common configuration - NFSv4
	
    file { '/etc/default/nfs-common':
        source =>  "puppet:///modules/puppet_nfs4srv/nfs-common",  
         owner => 'root',
         group => 'root',
		notify => Class["puppet_nfs4srv::service"],
    }
	
	# nfs-kernel-server configuration - NFSv4 - lock 'mountd' port to (4000)

    file { '/etc/default/nfs-kernel-server':
        source =>  "puppet:///modules/puppet_nfs4srv/nfs-kernel-server",  
         owner => 'root',
         group => 'root',
		notify => Class["puppet_nfs4srv::service"],
    }
	
	# Set fixed port (4001) for the 'lockd'. (rpcinfo -p shows details)
	
    file { '/etc/modprobe.d/options.conf':
        source =>  "puppet:///modules/puppet_nfs4srv/options.conf",  
         owner => 'root',
         group => 'root',
		notify => Class["puppet_nfs4srv::service"],
    }	
	
    file { '/etc/modules':
        source =>  "puppet:///modules/puppet_nfs4srv/modules",  
         owner => 'root',
         group => 'root',
		notify => Class["puppet_nfs4srv::service"],
    }	
	
}
