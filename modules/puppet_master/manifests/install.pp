##
## The 'manage puppet-master' itself
##
##
class puppet_master::install {

    ## Installation

    # Debian defaults to install puppet-common which
    # depends on facter - but just to show both.
    
    package { [ "puppetmaster", "facter" ] :
        ensure => present,
    }
    
    # if this host is the puppet server, given in $name , also install puppet
    # agent, and set service - but don't run puppet::config since
    # puppet.conf is named identical for P't master and P't agent
    
    if $hostname == 'carbon' {
      
        package { "puppet" :
            ensure => present,
        }

        service { "puppet":
            enable => false,
            hasrestart => true,
            ensure => stopped,
        }
    
    }
    
    
}