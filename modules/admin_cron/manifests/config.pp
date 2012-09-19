#
# Class admin_config configure cron
#
class admin_cron::config {

	include puppet_utils
    include admin_cron::params
    
    package { 'cron' :
        ensure => installed,
    }
    
    # create the allow file for root only
    
    puppet_utils::append_if_no_such_line { "Cron_allow_file_creation" :
            
        file => "/etc/cron.allow",
        line => "root" 
    
    }
    
    # set site 'default' time settings for cron hourly, daily, weekly and monthly
    # i.e. /etc/cron.hourly, /etc/daily, /etc/weekly and /etc/monthly
    
    $mailtorecipient = $::admin_cron::params::myrecipient
    
	file { "/etc/crontab" :
            content =>  template( 'admin_cron/crontab.erb' ),
		  owner => 'root',
		  group => 'root',
		require => Package["cron"],
	}    
    

}