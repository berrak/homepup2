##
## Puppet master service.
##
class puppet_master::service {

    service { "puppetmaster":
        enable => true,
        hasrestart => true,
        ensure => running,
        require => Class["puppet_master::install"],
    }
    
 
}