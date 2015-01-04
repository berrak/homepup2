##
## Manage NFSv4 client
##
##
class puppet_nfs4client::config {

    include puppet_nfs4client::params
	include puppet_nfs4client::install
	include puppet_nfs4client::service
	
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
