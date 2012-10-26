##
## This class manage resolv.conf DNS entries.
## If no DNS ip addresses is given OpenDNS is used.
##
## TODO: Move dns's to params and move subdomain up as class parameter.
## Now its quick fix to have postfix delivering mails from subdomains.
##
## Sample usage:
##
##  class { admin_resolvconf::config :
##		dns_ip_1st => 'XXX.XXX.XXX.XXX', dns_ip_2nd => 'XXX.XXX.YYY.YYY' }
##
class admin_resolvconf::config ( $dns_ip_1st = '208.67.222.222',
								 $dns_ip_2nd = '208.67.220.220',
) {

    include admin_resolvconf::params

	$mydomain = $::domain
	$dns1 = $dns_ip_1st
	$dns2 = $dns_ip_2nd
	
	$mysubdomain1 = $::admin_resolvconf::params::mysubdomain_1
	
	file { '/etc/resolv.conf' :
		content =>  template( 'admin_resolvconf/resolv.conf.erb' ),
		  owner => 'root',
		  group => 'root',
		   mode => '0644',
	}
	
	
}
