##
## This class manage resolv.conf DNS entries.
## 'dns_provider => ispdns | opendns' decides which
## dns servers to use (see params)
##
## Sample usage:
##
##  class { admin_resolvconf::config : dns_provider => 'opendns' }
##  class { admin_resolvconf::config : dns_provider => 'ispdns' }
##
class admin_resolvconf::config ( $dns_provider = '' ) {

    include admin_resolvconf::params

    if ! $dns_provider in [ 'opendns', 'ispdns' ] {
	
	    fail("FAIL: Unknown dns provider parameter ($dns_provider). Use 'opendns' or 'ispdns'")
	}

	case $dns_provider {
         
		 'ispdns': {
              $dns1 = $::admin_resolvconf::params::ispdns_ip_1st
	          $dns2 = $::admin_resolvconf::params::ispdns_ip_2nd
		 }
		 
         'opendns': {
              $dns1 = $::admin_resolvconf::params::opendns_ip_1st
	          $dns2 = $::admin_resolvconf::params::opendns_ip_2nd
		 }
	     default: {}
	}

    $mydomain = $::domain
	
	# handle sub domains for postfix mail delivery
	$mysubdomain1 = $::admin_resolvconf::params::mysubdomain_1
	
	file { '/etc/resolv.conf' :
		content =>  template( 'admin_resolvconf/resolv.conf.erb' ),
		  owner => 'root',
		  group => 'root',
		   mode => '0644',
	}
	
	
}
