#
# Install preseed define. The two preseed files are created
# with postfix alternatives Internet and Satellite.
# The preseeds files are created with ipv6 disabled.
#
# Sample usage:
#   puppet_postfix::install { 'mta' :
#                              ensure => installed,
#                            mta_type => server }
#
define puppet_postfix::install(
    $ensure ,
    $mta_type = 'satellite',
    $source = 'UNSET'
) {

    include puppet_postfix::params
    include puppet_utils

    if ! ( $ensure in [ "present", "installed" ]) {
        fail("FAIL: The package wanted state must be 'present' or 'installed' only.")
    }

    if ! ( $mta_type in [ "server", "satellite" ]) {
        fail("FAIL: The mta_type ($mta_type) must be either 'server' or 'satellite'.")
    }
    
    # Since our mailhost fqdn varies, create the file: '/etc/mailname' which holds
    # the fqdn to agent host. Then refer to that file in the preseed files.
    
    puppet_utils::append_if_no_such_line { "postfix_fqdn" :
            
        file => "/etc/mailname",
        line => "${::hostname}.${::domain}", 
    
    }
    
    # in case exim4 family of packages are installed - remove them, since
    # they conflicts with postfix. Note that mua 'bsd-mailx' is removed as well.
    
    package { "exim4" : ensure => absent }
    package { "exim4-base" : ensure => absent }
    package { "exim4-config" : ensure => absent }
    
    # now when we possible have removed the mail reader, let's install one.
    
    package { "heirloom-mailx" : ensure => present }
    
    
    # facter variables (assumes server interface is on eth0)
    
    $mynetwork_eth0 = $::network_eth0
    $mydomain = $::domain
    
    if ( $mta_type == 'server' ) {
    
        $server_source = $source ? {
            'UNSET' => "puppet:///modules/puppet_postfix/server.postfix.preseed",
            default => $source,
        }
        
        $serverpath = $::puppet_postfix::params::server_preseedfilepath
    
        file { "$serverpath" : 
             source => $server_source,
              owner => 'root',
              group => 'root',
        }
    
        package { "postfix" :   
                  ensure => $ensure,
            responsefile => "$serverpath",
            require      => File[ "$serverpath" ],    
        }
        
        # Now replace the Debian default configuration files with our templates
        
        #file { '/etc/postfix/main.cf' :
        #      content =>  template( 'puppet_postfix/server.main.cf.erb' ),
        #        owner => 'root',
        #        group => 'root',
        #      require => Package["postfix"],
        #}
    
        file { '/etc/postfix/master.cf' :
              content =>  template( 'puppet_postfix/server.master.cf.erb' ),
                owner => 'root',
                group => 'root',
              require => Package["postfix"],           
        }
        
        
        
        
    } elsif ( $mta_type == 'satellite' ) {
    
        $satellite_source = $source ? {
        'UNSET' => "puppet:///modules/puppet_postfix/satellite.postfix.preseed",
        default => $source,
        }
        
        $satellitepath = $::puppet_postfix::params::satellite_preseedfilepath
    
        file { "$satellitepath" : 
            source => $satellite_source,
             owner => 'root',
             group => 'root',
        }
    
        package { "postfix" :   
                  ensure => $ensure,
            responsefile => "$satellitepath",
            require      => File[ "$satellitepath" ],    
        }
        
        
    
    
    } else {
    
        fail( "FAIL: Unexpected mta_type ($mta_type) parameter failure." )
    
    }

}