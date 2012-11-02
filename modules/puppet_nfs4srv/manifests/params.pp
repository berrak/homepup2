##
## Manage NFSv4 server
##
class puppet_nfs4srv::params {

    # export the root 'pseudo filesystem'

    $export0 = '/mnt/exports  -sec=sys 192.168.0.0/24(ro,fsid=0)'    
    
    # export 'bekr' to user 'bekr' on host 192.168.0.100
    
    $export1 = '/mnt/exports/nfs-bekr  192.168.0.100(rw)'

}