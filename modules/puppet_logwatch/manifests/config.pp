#
# Class to manage logwatch
#
class puppet_logwatch::config {

    file { "/etc/logwatch/conf/logwatch.conf" :
		 source => "puppet:///modules/puppet_logwatch/logwatch.conf",
		  owner => 'root',
		  group => 'root',
		require => Package["logwatch"],
	}

}