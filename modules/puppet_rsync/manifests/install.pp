##
## Backup user data with rsync
##
class puppet_rsync::install {

    package { "rsync" :
        ensure => installed,
    }

}