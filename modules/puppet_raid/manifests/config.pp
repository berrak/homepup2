##
## Manage software raid
##
class puppet_raid::config {

    include puppet_raid::params
    
    if $::hostname == puppet_raid::params::raidhostname {
    
        file { '/etc/mdadm/mdadm.conf':
            source => "puppet:///modules/puppet_raid/mdadm.conf",    
             owner => 'root',
             group => 'root',
           require => Class["puppet_raid::install"],
        }
        
    }

}