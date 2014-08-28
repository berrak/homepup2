##
## puppet_cluster_ssh managage group of ssh servers
##
## Uasage: class { puppet_cluster_ssh::config : user => 'bekr' }
## 
##
class puppet_cluster_ssh::config ($user='') {
    

	if ( $user == '' ) {
		fail("FAIL: Missing user name!")
	}

	file { "/home/$user/.clusterssh":
		 ensure => "directory",
		  owner => $user,
		  group => $user,
		   mode => '0755',
	    require => Package['clusterssh'],
	}
	
	file { "/home/$user/.clusterssh/config" :
		content =>  template( 'puppet_cluster_ssh/config.erb' ),
		  owner => $user,
		  group => $user,
		   mode => '0644',
		require => File["/home/$user/.clusterssh"],
	}	
	
	# Definition of the cluster (i.e. server IP addresses)
	
	file { "/etc/clusters" :
		 source => "puppet:///modules/puppet_cluster_ssh/clusters",
		  owner => 'root',
		  group => 'root',
		   mode => '0644',
		require => Package['clusterssh'],
	}
	
	

}