##
## The 'manage puppet agent' itself class
##
class puppet_agent::install {
  
    # Debian defaults to install puppet-common which
    # depends on facter - but just to show both.
  
    package { [ "puppet", "facter" ] :
        ensure => present,
    }

}