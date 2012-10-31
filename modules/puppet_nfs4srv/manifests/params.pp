##
## Manage NFSv4 server
##
class puppet_nfs4srv::params {

    # export from nfs server to user 'bekr' on host 192.168.0.100
    
    $export1 = '/mnt/shireraid/nfs-bekr    -sec=sys,rw 192.168.0.100'

}