#
# Install preseed define. The preseed is created
# with selections 'no'-->'no'-->'ok' responses i.e. 
# create required keys by hand and only let package provide 
# the initial configuration and the sample policy files.
#
define puppet_tripwire::install(
    $ensure ,
    $source = 'UNSET'
) {


    if ! ( $ensure in [ "present", "installed" ]) {
        fail("The package wanted state must be 'present' or 'installed' only.")
    }

    # this is the original tripwire preseed file (replace this if required)
    
    $real_source = $source ? {
        'UNSET' => "puppet:///modules/puppet_tripwire/tripwire.preseed",
        default => $source,
    }
    
    # remove old preseed file every time to make sure we use updated version
    
    $preseedpath = $::puppet_tripwire::params::preseedfilepath
    
    exec { "remove_old_tripwire_preseed" :
        command => "/bin/sh 'if [ -f $preseedpath ] ; then /bin/rm $preseedpath ; fi'",

    } 

    file { "$preseedpath" : 
         source => $real_source,
          owner => 'root',
          group => 'root',
        require => Exec[ "remove_old_tripwire_preseed" ],
    }

    package { "tripwire" :   
              ensure => $ensure,
        responsefile => "$preseedpath",
        require      => File[ "$preseedpath" ],    
        }

}