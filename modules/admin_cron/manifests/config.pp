#
# Class admin_config configure cron
#
class admin_cron::config {

	include puppet_utils
    
    package { 'cron' :
        ensure => installed,
        notify => Exec
    }
    
    # facter
    
    $mycomputertype = $::type
    
    # anacron (cron-like program that doesn't go by time)
    if $mycomputertype == 'Notebook' {
        package  { "anacron" : ensure => installed }
    }
    
    # create the cron.allow (empty) file
    
	file { "/etc/cron.allow":
		ensure => present,
		 owner => 'root',
		 group => 'root',
		  mode => '0600',
	}
 
    # create the cron.deny file from all users in /etc/passwd, except root
    # Todo: not ideal, if /etc/passwd is updated, cron.deny is not aware.
    
    exec { "/bin/awk -F: '{print $1}' /etc/passwd | /bin/grep -v root > /etc/cron.deny":
        refreshonly => true,
          subscribe => File["/etc/cron.allow"],
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