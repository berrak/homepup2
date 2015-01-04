##
## Manage NFSv4 client - add nfs user client
##
## Usage:
##        puppet_nfs4client::add_user { 'bekr' : }
##
define puppet_nfs4client::add_user {

    include puppet_nfs4client
    
    $nfs_user = $name
    
    if $nfs_user == '' {
    
        fail("FAIL: Missing the user ($nfs_user) parameter")
    }

    # create local nfs mount directory for $nfs_user
    
	file { "/home/${nfs_user}/nfs":
		 ensure => "directory",
		  owner => $nfs_user,
		  group => $nfs_user,
           mode => '0755',
        require => Package['nfs-common']
	}


}
