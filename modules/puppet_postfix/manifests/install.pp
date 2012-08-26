#
# Install preseed define. The two preseed files are created
# with Debian postfix alternatives Internet and Satellite.
# Post-install configuration with templates after initial setup.
#
# Sample usage:
#   puppet_postfix::install { 'mta' :
#                              ensure => installed,
#                            mta_type => server,
#                no_lan_outbound_mail => 'true',
#                      smtp_relayhost_ip => '192.168.0.11' }
#
define puppet_postfix::install(
    $ensure ,
    $mta_type = 'satellite',
    $source = 'UNSET',
    $no_lan_outbound_mail = '',
    $smtp_relayhost_ip = ''
) {

    include puppet_postfix::params
    include puppet_postfix::service
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
    
    # now when we possible have removed the mua, let's install one
    # for testing sending emails.
    
    package { "heirloom-mailx" : ensure => present }
    
    
    # facter variables (assumes server interface is on eth0)
    
    $mynetwork_eth0 = $::network_eth0
    $mydomain = $::domain
    $myfqdn = $::fqdn
    
    # define template variables to control external net mail delivery

    if $no_lan_outbound_mail == 'true' {
        $lan_outbound_hold_service = 'hold      unix  -       -       -       -       -       smtp'
        
        $default_transport = 'default_transport = hold'
        $defer_transport = 'defer_transport = hold'            
    } else {
        $lan_outbound_hold_service = '#'
        
        $default_transport = ''
        $defer_transport = ''          
    }
    
    if ( $mta_type == 'server' ) {
    
        if ! ( $no_lan_outbound_mail in [ "true", "false" ]) {
            fail("FAIL: Allow outbound lan mail ($no_lan_outbound_mail) must be either true or false.")
        }
    
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
        
        # install mutt mail reader for IMAP tests.
        
        package { "mutt" : ensure => present }

        
        # Replace the Debian initial configuration files with our template
        
        file { '/etc/postfix/main.cf' :
              content =>  template( 'puppet_postfix/server.main.cf.erb' ),
                owner => 'root',
                group => 'root',
              require => Package["postfix"],
               notify => Service["postfix"],
        } 
    
        file { '/etc/postfix/master.cf' :
              content =>  template( 'puppet_postfix/server.master.cf.erb' ),
                owner => 'root',
                group => 'root',
              require => Package["postfix"],
               notify => Service["postfix"],
        }
        
        
    } elsif ( $mta_type == 'satellite' ) {
    
        if $smtp_relayhost_ip == '' {
            fail("FAIL: In a satellite configuration the FQDN must be given!")
        }
    
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
        
        # Replace the Debian initial configuration file with our template
        
        file { '/etc/postfix/main.cf' :
              content =>  template( 'puppet_postfix/satellite.main.cf.erb' ),
                owner => 'root',
                group => 'root',
              require => Package["postfix"],
               notify => Service["postfix"],
        } 
    
    
    } else {
    
        fail( "FAIL: Unexpected mta_type ($mta_type) parameter failure." )
    
    }

}