##
## Puppet configuration
##
class puppet::config {

    include puppet::params

    # default options for puppet (agent) e.g. run as daemon or not 

    file { "/etc/default/puppet" :
        ensure => present,
        source => "puppet:///modules/puppet/puppet",
        owner => 'root',
        group => 'root',
        require => Class["puppet::install"],
        notify => Class["puppet::service"],
    }
   

    # template variables

    $puppetserver = $::puppet::params::mypuppetserver_fqdn
    $puppetserverhostname = $::puppet::params::mypuppetserver_hostname
    $nodename = $::fqdn
    
    if $::hostname == $::puppet::params::mypuppetserver_hostname {
    
        file { "/etc/puppet/puppet.conf" :
            ensure => present,
            content => template("puppet/puppet.conf.master.erb"),
            owner => 'root',
            group => 'root',
            require => Class["puppet::install"],
            notify => Class["puppet::service"],
        }
        
        file { "/etc/puppet/auth.conf" :
            ensure => present,
            source => "puppet:///modules/puppet/auth.conf",
            owner => 'root',
            group => 'root',
            require => Class["puppet::install"],
            notify => Class["puppet::service"],
        }
        
        file { "/etc/puppet/fileserver.conf" :
            ensure => present,
            source => "puppet:///modules/puppet/fileserver.conf",
            owner => 'root',
            group => 'root',
            require => Class["puppet::install"],
            notify => Class["puppet::service"],
        }
        
    # default options for puppetmaster e.g. run as daemon or not 
        
        file { "/etc/default/puppetmaster" :
            ensure => present,
            source => "puppet:///modules/puppet/puppetmaster",
            owner => 'root',
            group => 'root',
            require => Class["puppet::install"],
            notify => Class["puppet::service"],
        }
        
    } else {
    
        file { "/etc/puppet/puppet.conf" :
            ensure => present,
            content => template("puppet/puppet.conf.agent.erb"),
            owner => 'root',
            group => 'root',
            require => Class["puppet::install"],
            notify => Class["puppet::service"],
        }
    
    }

}