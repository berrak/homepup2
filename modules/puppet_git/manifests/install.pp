##
## Install git and gitk
##
class puppet_git::install {

    package { "git":
        ensure => installed }
    
    package { "gitk":
        ensure => installed,
        require => Package["git"],
    }
    
}