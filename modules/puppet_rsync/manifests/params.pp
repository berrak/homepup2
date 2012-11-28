##
## Backup user data with rsync
##
class puppet_rsync::params {

    # host name of network backup server (runs as the 'rsync' server)
    
    $rsync_server_hostname = 'warp'
    $rsync_server_address = '192.168.2.83'
    
    
    # configuration for server (for client also the $secretsfile, only
    # required for cron job and the desktop that acts as the NFS share)
    
    $secretsfile = '/root/rsyncd.pwd'
    
    
    # user/host that requires a special sub directory at the backup server
    
    $nfs_host_for_rsync = 'shire'
    $nfs_user_for_rsync = 'bekr'
    
}