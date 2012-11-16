#
# Class to manage logwatch cron and conf files
#
class puppet_logwatch::config {

    include puppet_logwatch::params
    
    $mailtorecepient = $::puppet_logwatch::params::myrcpt

    file { '/etc/cron.daily/00logwatch' :
        content =>  template( 'puppet_logwatch/00logwatch.erb' ),
		 ensure => present,
          owner => 'root',
          group => 'root',
           mode => '0755',
		require => Package["logwatch"],           
    }

    file { '/etc/logwatch/conf/logwatch.conf' :
		content =>  template( 'puppet_logwatch/logwatch.conf.erb' ),
		  owner => 'root',
		  group => 'root',
		require => Package["logwatch"],
	}
	
	# in case default /tmp directory is changed, create /var/cache/logwatch
	
    file { "/var/cache/logwatch":
		 ensure => "directory",
		  owner => 'root',
	 	  group => 'root',
	}	
	
}