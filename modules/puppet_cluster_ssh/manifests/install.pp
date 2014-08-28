##
## puppet_cluster_ssh managage group of ssh servers
##
class puppet_cluster_ssh::install {
    
	    package { "clusterssh":
			ensure => installed,
			require => Class['puppet_ssh'],
		}

        
}