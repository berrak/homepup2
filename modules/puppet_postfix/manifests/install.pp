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
    
        $real_source = $source ? {
            'UNSET' => "puppet:///modules/puppet_postfix/server.postfix.preseed",
            default => $source,
        }
        
        $serverpath = $::puppet_postfix::params::server_preseedfilepath
        
        # remove old preseed file every time to make sure we use updated version
        exec { "remove_old_server_preseed" :
            command => "test -f $serverpath && rm $serverpath",
               path => "/usr/bin:/bin",
        }
    
        file { "$::puppet_postfix::params::server_preseedfilepath" : 
            source => $real_source,
             owner => 'root',
             group => 'root', 
        }
    
        package { "postfix" :   
                  ensure => $ensure,
            responsefile => "$::puppet_postfix::params::server_preseedfilepath",
            require      => File[ "$::puppet_postfix::params::server_preseedfilepath" ],    
            }
        
        
    } elsif ( $mta_type == 'satellite' ) {
    
        $real_source = $source ? {
        'UNSET' => "puppet:///modules/puppet_postfix/server.postfix.preseed",
        default => $source,
        }
        
        $satellitepath = $::puppet_postfix::params::satellite_preseedfilepath
        
        # remove old preseed file every time to make sure we use updated version
        exec { "remove_old_satellite_preseed" :
            command => "test -f $satellitepath && rm $satellitepath",
               path => "/usr/bin:/bin",
        }
    
        file { "$::puppet_postfix::params::satellite_preseedfilepath" : 
            source => $real_source,
             owner => 'root',
             group => 'root', 
        }
    
        package { "postfix" :   
                  ensure => $ensure,
            responsefile => "$::puppet_postfix::params::satellite_preseedfilepath",
            require      => File[ "$::puppet_postfix::params::satellite_preseedfilepath" ],    
        }
    
    
    } else {
    
        fail( "FAIL: Unexpected mta_type ($mta_type) parameter failure." )
    
    }

}