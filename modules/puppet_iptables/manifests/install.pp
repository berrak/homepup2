##
## This class manage iptables
##
class puppet_iptables::install {

    package  { 'iptables' :
                ensure => installed }

	file { "/etc/rc.local" :
		 source => "puppet:///modules/puppet_iptables/rc.local",
		  owner => 'root',
		  group => 'root',
		   mode => '0750',
		require => Package["iptables"],
	}	

}
