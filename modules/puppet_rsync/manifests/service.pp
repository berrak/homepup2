##
## Backup user data with rsync
##
class puppet_rsync::service {

    include puppet_rsync::params
    
    # only run the rsync daemon on the server
    
    if $::hostname == $::puppet_rsync::params::rsync_server_hostname {
    
        exec { "restart_rsync_daemon_conf":
                command => "/bin/bash /etc/init.d/rsync restart",
              subscribe => File["/etc/rsyncd.conf"],
            refreshonly => true,
        }
        
        exec { "restart_rsync_daemon_default":
                command => "/bin/bash /etc/init.d/rsync restart",
              subscribe => File["/etc/default/rsync"],
            refreshonly => true,
        }
 
    }
    
}