##
## Manage logserver remote received syslogs with 'logcheck'
##
class puppet_logcheck::config {

    include puppet_logcheck::params
    
        if $::hostname == $::puppet_logcheck::params::myloghost {
        
            file { '/etc/logcheck/logcheck.conf':
                 source => "puppet:///modules/puppet_logcheck/logcheck.conf",        
                  owner => 'root',
                  group => 'logcheck',
                   mode => '0640',
                require => Class["puppet_logcheck::install"],
            }
            
            # email header text (if enabled in configuration)
        
            file { '/etc/logcheck/header.txt':
                 source => "puppet:///modules/puppet_logcheck/header.txt",  
                  owner => 'root',
                  group => 'logcheck',
                  mode => '0640',
                require => Class["puppet_logcheck::install"],
            }
        
        }
        

}