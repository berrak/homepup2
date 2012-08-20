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
    
    $real_source = $source ? {
        'UNSET' => "puppet:///modules/puppet_postfix/${mta_type}.postfix.preseed",
        default => $source,
    }
    
    # Since our mailhost fqdn varies, create the file: '/etc/mailname' which holds
    # the fqdn to agent host. Then refer to that file in the preseed files.
    
    puppet_utils::append_if_no_such_line { "postfix_fqdn" :
            
        file => "/etc/mailname",
        line => "${::hostname}.${::domain}", 
    
    }
    
    
    # Use of qualified varaiables requires no hyphens in class names!

    file { "$::puppet_postfix::params::mta_type_preseedfilepath" : 
        source => $real_source,
         owner => 'root',
         group => 'root', 
    }

    package { postfix :   
              ensure => $ensure,
        responsefile => "$::puppet_postfix::params::mta_type_preseedfilepath",
        require      => File[ "$::puppet_postfix::params::mta_type_preseedfilepath" ],    
        }

}