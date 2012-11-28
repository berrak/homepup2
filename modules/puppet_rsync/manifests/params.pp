##
## Backup user data with rsync
##
class puppet_rsync::params {

    # host name of network backup server (runs as the 'rsync' server)
    
    $rsync_server_hostname = 'warp'
    $rsync_server_address = '192.168.2.83'
    
    
    # configuration for server (for client also the $secretsfile, only
    # required for cron job and the desktop that acts as the NFS share)
    
    $authuser1 = 'bekr'
    $secretsfile = '/root/rsyncd.pwd'
    
    # only these hosts are allowed to connect to backup (rsync) server
    
    $hostallowip = '192.168.0.10' 
    
    
    # client list of (desktops) hosts (names) which will use rsync to backup user data
    
    $hostlist_for_rsync = [ 'shire', 'mordor' ]
    
    #############################################
    # remove this stanza when above works
    $nfs_host_for_rsync = 'shire'
    
}