#
# Class to manage logwatch cron and conf files
#
class puppet_logwatch::config {

    include puppet_logwatch::params

    $mydomain = $::domain 
    $rcpt = $::puppet_logwatch::params::myrcpt
    
    $mailtorecepient = "${rcpt}@${mydomain}"

    file { '/etc/cron.daily/00logwatch' :
        content =>  template( 'puppet_logwatch/00logwatch.erb' ),
          owner => 'root',
          group => 'root',
    }

    file { '/etc/logwatch/conf/logwatch.conf' :
		 source => "puppet:///modules/puppet_logwatch/logwatch.conf",
		  owner => 'root',
		  group => 'root',
		require => Package["logwatch"],
	}

}