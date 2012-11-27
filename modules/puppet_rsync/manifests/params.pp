##
## Backup user data with rsync
##
class puppet_rsync::params {

    # host name of network backup server (runs as the 'rsync' server)
    
    $rsync_server_hostname = 'warp'
    $rsync_server_address = '192.168.2.83'
    
    
    # configuration for server (and client also $secretsfile)
    
    $authuser1 = 'bekr'
    $secretsfile = '/root/rsyncd.pwd'
    $hostallowip = '192.168.0.10' 
    
    # client server and distribution in use
    
    $nfs_host_for_rsync = 'shire'
    
}