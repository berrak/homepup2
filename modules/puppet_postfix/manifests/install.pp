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
           
        # remove the preseed file every time to make
        # sure we always use an updated version 
        exec { "remove_old_server_preseed" :
            command => "/bin/rm $serverpath",
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
        
        # remove the preseed file every time to make
        # sure we always use an updated version
        
        exec { "remove_old_satellite_preseed" :
            command => "/bin/rm $satellitepath",
            require => Package["postfix"],
        }
    
    
    } else {
    
        fail( "FAIL: Unexpected mta_type ($mta_type) parameter failure." )
    
    }

}