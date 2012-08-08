##
## Puppet configuration class
##
class puppet_master::config {

    include puppet_master::params

    $puppetserver = $::puppet_master::params::mypuppetserver_fqdn
    $puppetserverhostname = $::puppet_master::params::mypuppetserver_hostname
    
    $nodename = $::fqdn
    
    file { "/etc/puppet/puppet.conf" :
        ensure => present,
        content => template("puppet_master/puppet.conf.erb"),
        owner => 'root',
        group => 'root',
        require => Class["puppet_master::install"],
        notify => Class["puppet_master::service"],
    }
    
    
    
    file { "/etc/puppet/auth.conf" :
        ensure => present,
        source => "puppet:///modules/puppet_master/auth.conf",
        owner => 'root',
        group => 'root',
        require => Class["puppet_master::install"],
        notify => Class["puppet_master::service"],
    }
    
    file { "/etc/puppet/fileserver.conf" :
        ensure => present,
        source => "puppet:///modules/puppet_master/fileserver.conf",
        owner => 'root',
        group => 'root',
        require => Class["puppet_master::install"],
        notify => Class["puppet_master::service"],
    }
     

}