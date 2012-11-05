##
## This class starts the NFS service
##
class puppet_nfs4srv::service {

	service { "nfs-kernel-server":
		
		    ensure => running,
		 hasstatus => true,
		hasrestart => true,
		    enable => true,
		   require => Service["nfs-common"],
	}	

	service { "nfs-common":
		
		    ensure => running,
		 hasstatus => true,
		hasrestart => true,
		    enable => true,
		   require => Class["puppet_nfs4srv::install"],
	}


}
