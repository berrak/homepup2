##
## Manage logserver remote received syslogs with 'logcheck'
##
class puppet_logcheck::config {

    include puppet_logcheck::params
    
        if $::hostname == $::puppet_logcheck::params::myloghost {
        
            file { '/etc/logcheck/logcheck.conf':
                owner => 'root',
                group => 'root',
                source => "puppet:///modules/puppet_logcheck/logcheck.conf",
                require => Class["puppet_logcheck::install"],
            }
        
        
            # list of logfiles to check
        
            file { '/etc/logcheck/logcheck.logfiles':
                owner => 'root',
                group => 'root',
                source => "puppet:///modules/puppet_logcheck/logcheck.logfiles",
                require => Class["puppet_logcheck::install"],
            }
            
            
            # email haeder text
        
            file { '/etc/logcheck/header.txt':
                owner => 'root',
                group => 'root',
                source => "puppet:///modules/puppet_logcheck/header.txt",
                require => Class["puppet_logcheck::install"],
            }
        
        
        }
        

}