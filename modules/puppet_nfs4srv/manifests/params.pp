##
## Manage NFSv4 server
##
class puppet_nfs4srv::params {

    # export from nfs server to user 'bekr' on host 192.168.0.100
    
    $export1 = '/mnt/exports/nfs-bekr    -sec=sys,rw 192.168.0.100'

}