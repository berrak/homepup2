#
# Class admin_config configure cron
#
class admin_cron::config {

	include puppet_utils
    
    package { 'cron' :
        ensure => installed,
    }
    
    # Install anacron if laptop
    
    if $::type == 'Notebook' {
    
        package { 'anacron' :
             ensure => installed,
            require => Package["cron"],
        }
    }
    
    # restrict who can use cron to only root
    
    file { "/root/bin/cron.restrict":
         source => "puppet:///modules/admin_cron/cron.restrict",
          owner => 'root',
          group => 'root',
           mode => '0700',
        require => Package["cron"],
         notify => Exec["/root/bin/cron.restrict"],
    }
    
    # create the cron.allow (empty) file and create the cron.deny
    # file from all users in /etc/passwd, except root.
    # Todo: not ideal, if /etc/passwd is updated, cron.deny is not aware.
    
    exec { "/root/bin/cron.restrict":  
        refreshonly => true,
            require => File["/root/bin/cron.restrict"],
    }
    
    # set site 'default' time settings for cron hourly, daily, weekly and monthly
    # i.e. /etc/cron.hourly, /etc/daily, /etc/weekly and /etc/monthly
    
    file { "/etc/crontab":
         source => "puppet:///modules/admin_cron/crontab",
          owner => 'root',
          group => 'root',
        require => Package["cron"],
    }
    
}