##
## Manage NFSv4 client - add nfs user client
##
## Usage:
##        puppet_nfs4client::add_user { 'bekr' : }
##
define puppet_nfs4client::add_user {

    include puppet_nfs4client
        
    if $name == '' {
    
        fail("FAIL: Missing the user ($name) parameter")
    }

    # create local nfs mount directory for $name
    
	file { "/home/$name/nfs":
		 ensure => "directory",
		  owner => $name,
		  group => $name,
           mode => '0755',
        require => Package["nfs-common"],
	}


}
