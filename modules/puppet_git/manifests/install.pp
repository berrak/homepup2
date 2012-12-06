##
## Install git and gitk
##
class puppet_git::install {

    include puppet_git::params

    package { "git":
        ensure => installed }
    
    # only install gitk viewer in GUI desktops
    case $::hostname {
    
        'carbon',
        'mordor',
        'shire' : {
        
            package { "gitk":
                ensure => installed,
                require => Package["git"],
            }
    
    }
    
}