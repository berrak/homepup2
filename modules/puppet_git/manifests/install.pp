##
## Install git and gitk
##
class puppet_git::install {

    include puppet_git::params

    package { "git":
        ensure => installed }
    
    # only install gitk viewer in GUI desktops
    case $::hostname {
    
        $::puppet_git::params::git_serverlist: {
        
            notice("Skipping install of graphical gitk on git server.")
        
        }

        default: {
        
            package { "gitk":
                ensure => installed,
                require => Package["git"],
            }

        }
    
    }
    
}