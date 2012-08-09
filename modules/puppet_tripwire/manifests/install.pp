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

    # this is the original tripwire pressed file (replace this if required)
    
    $real_source = $source ? {
        'UNSET' => "puppet:///modules/puppet_tripwire/tripwire.preseed",
        default => $source,
    }
    
    # Use of qualified varaiables requires no hyphens in class names!

    file { $puppet_tripwire::params::preseedfilepath : 
        source => $real_source,
         owner => 'root',
         group => 'root', 
    }

    package { tripwire :   
              ensure => $ensure,
        responsefile => $puppet_tripwire::params::preseedfilepath,
        require      => File[ $puppet_tripwire::params::preseedfilepath ],    
        }

}