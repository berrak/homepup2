#
# Class admin_config configure cron
#
class admin_cron::config {

	include puppet_utils
    
    package { 'cron' :
        ensure => installed,
    }
    
    # create the allow file for root only
    
    puppet_utils::append_if_no_such_line { "Cron_allow_file_creation" :
            
        file => "/etc/cron.allow",
        line => "root" 
    
    }
    
    # set 'default' time settings for cron hourly, daily, weekly and monthly
    
    file { "/etc/crontab":
        source => "puppet:///modules/admin_cron/crontab",
         owner => 'root',
         group => 'root',
    }


}