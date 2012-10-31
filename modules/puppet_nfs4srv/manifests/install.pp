##
## Manage NFSv4 server
##
class puppet_nfs4srv::install {

    package { "nfs-common" : ensure => installed } 
    
    package { "nfs-kernel-server" :
         ensure => installed,
        require => Package["nfs-common"],
    } 

}