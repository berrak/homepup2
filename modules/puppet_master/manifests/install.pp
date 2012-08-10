##
## The 'manage puppet-master' itself
##
##
class puppet_master::install {

    include puppet_master::params

    # Debian defaults to install puppet-common which
    # depends on facter - but just to show both.
    
    package { [ "puppetmaster", "facter" ] :
        ensure => present,
    }
    
    # If this host is the puppet server, also install the puppet
    # agent, and set service - but don't run puppet::config since
    # puppet.conf is named identical for P't master and P't agent.
    # 'files' stores possible Debian preseed files for appl. installs
    
    if $hostname == $::puppet_master::params::mypuppetserver_hostname {
      
        package { "puppet" :
            ensure => present,
        }

        service { "puppet":
            enable => false,
            hasrestart => true,
            ensure => stopped,
            require => File["/etc/puppet/files"],
        }
    
    }
    
    
}