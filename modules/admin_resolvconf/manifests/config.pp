##
## This class manage resolv.conf DNS entries.
## If no DNS ip addresses is given OpenDNS is used.
##
## Sample usage:
##
##  class { admin_resolvconf::config :
##		dns_ip_1st => 'XXX.XXX.XXX.XXX', dns_ip_2nd => 'XXX.XXX.YYY.YYY' }
##
class admin_resolvconf::config ( $dns_ip_1st = '208.67.222.222',
								 $dns_ip_2nd = '208.67.220.220',
) {

	$mylocaldomain = $::domain
	$dns1 = $dns_ip_1st
	$dns2 = $dns_ip_2nd
	
	file { '/etc/resolv.conf' :
		content =>  template( 'admin_resolvconf/resolv.conf.erb' ),
		  owner => 'root',
		  group => 'root',
		   mode => '0644',
	}
	
	
}
