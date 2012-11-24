##
## Backup user data with rsync
##
class puppet_rsync::service {

    include puppet_rsync::params
    
    if $::hostname == $::puppet_rsync::params::rsync_server_hostname {
    
        service { 'rsync':
            ensure => running,
            enable => true,
            require => Class["puppet_rsync::config"],
        }
        
        
 
    }
    


}