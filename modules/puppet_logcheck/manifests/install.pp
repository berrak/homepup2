##
## Manage logserver remote received syslogs with 'logcheck'
##
class puppet_logcheck::install {

    include puppet_logcheck::params
    
    if $::hostname == $::puppet_logcheck::params::myloghost {

        package { "logcheck" :
            ensure => installed,
        }
            
        package { "logcheck-database" :
             ensure => installed,
            require => Package["logcheck"],
        }
    
    }

}