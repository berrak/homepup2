##
## Puppet client service.
## Run puppet by cron, not as daemon.
## No init start-up scripts.
##
class puppet_agent::service {

    service { "puppet":
        enable => false,
        hasrestart => true,
        ensure => stopped,
        require => Class["puppet_agent::install"],
    }
    
 
}