##
## Manage NFSv4 server
##
class puppet_nfs4srv::params {

    # export the nfs root 'pseudo filesystem' to internal net

    $export0 = '/exports/nfs -sec=sys,ro,no_subtree_check 192.168.0.0/24(fsid=0)'
    
    # export the local nfs/bekr to other hosts were user have an account
    
    $export1 = '/exports/nfs/bekr 192.168.0.100/24(rw)'

}