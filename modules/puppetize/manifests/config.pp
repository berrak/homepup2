##
## Puppet configuration
##
class puppetize::config {

    include puppetize::params

    # default options for puppet (agent) e.g. run as daemon or not 

    file { "/etc/default/puppet" :
        ensure => present,
        source => "puppet:///modules/puppetize/puppet",
        owner => 'root',
        group => 'root',
        require => Class["puppetize::install"],
        notify => Class["puppetize::service"],
    }
   

    # template variables

    $puppetserver = $::puppetize::params::mypuppetserver_fqdn
    $puppetserverhostname = $::puppetize::params::mypuppetserver_hostname

    
    # The alternate fqdn for the puppet client (client and master on same host)
    $clientpuppetnodename = $::puppetize::params::mypuppetserverclient_node_fqdn
    
    if $::hostname == $::puppetize::params::mypuppetserver_hostname {
    
        file { "/etc/puppet/puppet.conf" :
            ensure => present,
            content => template("puppetize/puppet.conf.master.erb"),
            owner => 'root',
            group => 'root',
            require => Class["puppetize::install"],
            notify => Class["puppetize::service"],
        }
        
        file { "/etc/puppet/auth.conf" :
            ensure => present,
            source => "puppet:///modules/puppetize/auth.conf",
            owner => 'root',
            group => 'root',
            require => Class["puppetize::install"],
            notify => Class["puppetize::service"],
        }
        
        file { "/etc/puppet/fileserver.conf" :
            ensure => present,
            source => "puppet:///modules/puppetize/fileserver.conf",
            owner => 'root',
            group => 'root',
            require => Class["puppetize::install"],
            notify => Class["puppetize::service"],
        }
        
    # default options for puppetmaster e.g. run as daemon or not 
        
        file { "/etc/default/puppetmaster" :
            ensure => present,
            source => "puppet:///modules/puppetize/puppetmaster",
            owner => 'root',
            group => 'root',
            require => Class["puppetize::install"],
            notify => Class["puppetize::service"],
        }
        
    } else {
    
        file { "/etc/puppet/puppet.conf" :
            ensure => present,
            content => template("puppetize/puppet.conf.agent.erb"),
            owner => 'root',
            group => 'root',
            require => Class["puppetize::install"],
            notify => Class["puppetize::service"],
        }
    
    }

}