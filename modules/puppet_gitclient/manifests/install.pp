##
## Install git and gitk
##
class puppet_gitclient::install {

    package { "git": ensure => installed }
    
    # Note: only install gitk viewer in GUI desktops
    
    package { "gitk":
        ensure => installed,
        require => Package["git"],
    }

}