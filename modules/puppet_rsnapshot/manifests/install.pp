##
## Backup user data with rsnapshot
##
class puppet_rsnapshot::install {

    # installs 'rsync' if not already
    # installed (as required dependency)
    
    package { "rsnapshot" :
        ensure => installed,
    }

}
