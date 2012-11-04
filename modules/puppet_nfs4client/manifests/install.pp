##
## Manage NFSv4 client
##
class puppet_nfs4client::install {

    package { "nfs-common" : ensure => installed } 
    
}