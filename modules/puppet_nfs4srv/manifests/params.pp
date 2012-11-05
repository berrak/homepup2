##
## Manage NFSv4 server
##
class puppet_nfs4srv::params {

    # export the nfs root 'pseudo filesystem' to internal net

    $export0 = '/exports/nfs 192.168.0.0/24(rw,fsid=0,no_subtree_check)'

}