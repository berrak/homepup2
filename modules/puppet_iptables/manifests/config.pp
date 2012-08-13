##
## This class manage iptables
##
class puppet_iptables::config {

	include puppet_iptables::params
	
	if ( $::hostname == $::puppet_iptables::params::mygateway_hostname ) {
	
		file { "/root/bin/fw.gateway":
		    content => template( "puppet_iptables/fw.${::hostname}.erb" ),
		      owner => 'root',
		      group => 'root',
		       mode => '0700',
		    require => File["/root/bin"],
		     notify => Exec["/bin/sh /root/bin/fw.gateway"],
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

    }

}
