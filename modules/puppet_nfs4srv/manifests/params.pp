##
## Manage NFSv4 server
##
class puppet_nfs4srv::params {

    # export the root 'pseudo filesystem' to internal net

    $export0 = '/mnt/exports  -sec=sys 192.168.0.0/24(rw,fsid=0,no_subtree_check)'    

}