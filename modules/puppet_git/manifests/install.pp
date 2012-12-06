##
## Install git and gitk
##
class puppet_git::install {

    include puppet_git::params

    package { "git":
        ensure => installed }
    
    # only install gitk viewer in GUI desktops
    
    if ! $::hostname in $::puppet_git::params::git_serverlist {
    
        package { "gitk":
            ensure => installed,
            require => Package["git"],
        }
    
    }
    
}