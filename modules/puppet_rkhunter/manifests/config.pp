#
# Class to manage rkhunters config file
#
class puppet_rkhunter::config {

    include puppet_rkhunter::params
    
    # rkhunter requires a whitespace separated list for each recipient
    $mailtorecepientlist = "$::puppet_rkhunter::params::myrcptdomain $::puppet_rkhunter::params::mylocalroot"

    file { '/etc/rkhunter.conf' :
        content =>  template( 'puppet_rkhunter/rkhunter.conf.erb' ),
          owner => 'root',
          group => 'root',
        require => Package["rkhunter"],
    }


}