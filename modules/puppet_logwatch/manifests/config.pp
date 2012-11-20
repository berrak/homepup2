#
# Class to manage logwatch cron and conf files
#
class puppet_logwatch::config {

    include puppet_logwatch::params
    
    file { '/etc/cron.d/logwatch' :
         source =>  "puppet:///modules/puppet_logwatch/logwatch",
          owner => 'root',
          group => 'root',
           mode => '0644',
		require => Package["logwatch"],           
    }

	# This is NON-executable file that prevents maintainer changes
	# or run-parts to execute a daily cron job (is now run in cron.d)
	
    file { '/etc/cron.daily/00logwatch' :
         source =>  "puppet:///modules/puppet_logwatch/00logwatch.dummy",
          owner => 'root',
          group => 'root',
           mode => '0644',
		require => Package["logwatch"],           
    }


    $mailtorecepient = $::puppet_logwatch::params::myrcpt

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