##
## Manage NFSv4 server
##
class puppet_nfs4srv::params {

    # export the nfs root 'pseudo filesystem' to internal net

    $export0 = '/exports/usernfs4 192.168.0.0/24(rw,fsid=0,no_subtree_check)'
    
    
    # export users subtrees (see 'bind mounts' in fstab for user sharing content)
    
    $export1 = '/exports/usernfs4/bekr 192.168.0.100/24(rw,no_subtree_check)'
    $export2 = '/exports/usernfs4/bekr 192.168.0.222/24(rw,no_subtree_check)'
    $export3 = '/exports/usernfs4/bekr 192.168.0.24/24(rw,no_subtree_check)'
    
    $rootexport1 = '/exports/usernfs4/root 192.168.0.66/24(rw,no_subtree_check)'
    
}
