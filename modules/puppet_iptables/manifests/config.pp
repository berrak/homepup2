##
## This class manage iptables
##
class puppet_iptables::config {

	# facter (assumes eth0 always primary, and the internal iface)
	
    $myhostaddr = $::ipaddress_eth0
	
	include puppet_iptables::params
	
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
	
	
	if ( $::hostname == $::puppet_iptables::params::mygateway_hostname ) {
	
		file { "/root/bin/fw.gateway":
		    content => template( "puppet_iptables/fw.${::hostname}.erb" ),
		      owner => 'root',
		      group => 'root',
		       mode => '0700',
		    require => File["/root/bin"],
		     notify => Exec["/bin/sh /root/bin/fw.gateway"],
		}
		
		exec { "/bin/sh /root/bin/fw.gateway":
		    refreshonly => true,
	}
		
	
	} else {
	
		file { "/root/bin/fw.desktop":
		    content => template( "puppet_iptables/fw.desktop.erb" ),
		      owner => 'root',
		      group => 'root',
		       mode => '0700',
		    require => File["/root/bin"],
		     notify => Exec["/bin/sh /root/bin/fw.desktop"],
	    }
		
		exec { "/bin/sh /root/bin/fw.desktop":
		    refreshonly => true,
	    }
		
		
		

    }

}
