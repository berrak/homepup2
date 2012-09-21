#
# Class to manage rkhunters config file
#
class puppet_rkhunter::config {

    include puppet_rkhunter::params
    
    # Who should receive email alerts
    
    $mailtorecepientlist = $::puppet_rkhunter::params::rcptlist

    file { '/etc/rkhunter.conf' :
        content =>  template( 'puppet_rkhunter/rkhunter.conf.erb' ),
          owner => 'root',
          group => 'root',
        require => Package["rkhunter"],
    }
    
    # update hashfile database whenever 'rkhunter.conf' is changed
    # and that includes when rkhunter package is installed.
    
    exec { "update_rkhunter_filehash_database":
		command => '/usr/bin/rkhunter --propupd',
		subscribe => File["/etc/rkhunter.conf"],
		refreshonly => true,
	}
    
    
    # set default options for rkhunter. This file is sourced by
    # cron.daily and cron.weekly and apt.conf.d for rkhunter
    
    file { "/etc/default/rkhunter":
         source => "puppet:///modules/puppet_rkhunter/rkhunter",
          owner => 'root',
          group => 'root',
        require => Package["rkhunter"],
    }


}