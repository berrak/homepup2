##
## Manage NFSv4 client
##
## Usage:
##     class { puppet_nfs4client: user => 'bekr' }
##
class puppet_nfs4client::config ( $user ='' ) {

    include puppet_nfs4client::params
	include puppet_nfs4client::install

    if $user == '' {
    
        fail("FAIL: Missing the user ($user) parameter")
    }

    # create local nfs mount directory for $user
    
	file { "/home/$user/nfs-${user}":
		ensure => "directory",
		 owner => $user,
		 group => $user,
         mode => '0750',
	}

}