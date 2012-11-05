##
## Manage NFSv4 client
##
## Usage:
##     class { puppet_nfs4client: user => 'bekr' }
##
class puppet_nfs4client::config ( $user ='' ) {

    include puppet_nfs4client::params
	include puppet_nfs4client::install
	include puppet_nfs4client::service

    if $user == '' {
    
        fail("FAIL: Missing the user ($user) parameter")
    }

    # create local nfs mount directory for $user
    
	file { "/home/$user/nfs":
		ensure => "directory",
		 owner => $user,
		 group => $user,
          mode => '0750',
	}
	
	# nfs-common configuration - note: pure NFSv4 doesn't need legacy NFSv3 daemons
	
    file { '/etc/default/nfs-common':
        source =>  "puppet:///modules/puppet_nfs4client/nfs-common",  
         owner => 'root',
         group => 'root',
		notify => Class["puppet_nfs4client::service"],
    }

    # the UID/GID mapping daemon configuration

	$mydomain = $::domain
	
    file { '/etc/idmapd.conf':
        content =>  template( 'puppet_nfs4client/idmapd.conf.erb' ),  
          owner => 'root',
          group => 'root',
		 notify => Class["puppet_nfs4client::service"],
    }	

}