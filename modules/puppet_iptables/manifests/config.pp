##
## This class manage iptables rules. If not $hostnm is given a generic set
## of iptables rules is used based on $role. If $hostnm is given, this
## overrides $role, and a specific $hostnm rule are used instead.
##
## Sample usage:
##     class { puppet_iptables::config : role => 'server' }
##     class { puppet_iptables::config : role => 'server', hostnm => 'rohan' }
##
class puppet_iptables::config ( $role,
                                $hostnm='',
) {

    include puppet_iptables

    if ! ( $role in [ "default", "server", "desktop", "gateway", "puppetmaster" ]) {
	
		fail("Unknown role parameter ($role).")
	
	}

	## We assumes eth0 always primary, and used as the lan internal iface.
	
    $myhostaddr = $::ipaddress_eth0
	
    $net_int = $::puppet_iptables::params::net_int
    $if_int = $::puppet_iptables::params::if_int
    
    $ntphostaddr = $::puppet_iptables::params::ntphostaddr
    
    $netprn_hp3015_addr = $::puppet_iptables::params::netprn_hp3015_addr
    
    $mdnsmulticastaddr = $::puppet_iptables::params::mdnsmulticastaddr
    $puppetmasterhostaddr = $::puppet_iptables::params::puppetmasterhostaddr

    $gwhostaddr = $::puppet_iptables::params::gwhostaddr
    
    $net_ext = $::puppet_iptables::params::net_ext
    $gwhostextaddr = $::puppet_iptables::params::gwhostextaddr
    $if_ext = $::puppet_iptables::params::if_ext
		
		
    ## Select which iptables rule set to distribute 
	
	if ( $hostnm == '' ) {
	
		file { "/root/bin/fw.${role}":
		    content => template( "puppet_iptables/fw.${role}.erb" ),
		      owner => 'root',
		      group => 'root',
		       mode => '0700',
		    require => File["/root/bin"],
		     notify => Exec["/bin/sh /root/bin/fw.${role}"],
		}
		
		exec { "/bin/sh /root/bin/fw.${role}":
		    refreshonly => true,
	    }
		
     } elsif ( $hostnm == 'rohan' ) {
	
		file { "/root/bin/fw.rohan":
		    content => template( "puppet_iptables/fw.rohan.erb" ),
		      owner => 'root',
		      group => 'root',
		       mode => '0700',
		    require => File["/root/bin"],
		     notify => Exec["/bin/sh /root/bin/fw.rohan"],
		}
		
		exec { "/bin/sh /root/bin/fw.rohan":
		    refreshonly => true,
	    }
	
     } else {
	
		fail("Unknown parameter hostnm ($hostnm) given.")

    }

}
