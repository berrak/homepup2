##
## This class starts the NFS service
##
class puppet_nfs4client::service {

	service { "nfs-common":
		
		    ensure => running,
		 hasstatus => true,
		hasrestart => true,
		    enable => true,
		   require => Class["puppet_nfs4client::install"],

	}

}
