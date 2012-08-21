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
    
    $preseedpath = $::puppet_tripwire::params::preseedfilepath

    file { "$preseedpath" : 
         source => $real_source,
          owner => 'root',
          group => 'root',
    }

    package { "tripwire" :   
              ensure => $ensure,
        responsefile => "$preseedpath",
        require      => File[ "$preseedpath" ],    
        }
        
    # remove the preseed file every time to make sure we
    # always use an updated version next run.
    exec { "remove_old_tripwire_preseed" :
            command => "/bin/rm $preseedpath",
    }

}