#
# Class to install package virtualbox
#
class puppet_virtualbox::install {

    
    if ! ( $::architecture == 'amd64' ) {
        fail("FAIL: The given host architecture ($::architecture) must be 'amd64' only.")
    }
    
    # Add Oracle to sources.list.d and copy Oracle key
    
    file { '/etc/apt/sources.list.d/oracle.list' :
         source =>  "puppet:///modules/puppet_virtualbox/oracle.list",
          owner => 'root',
          group => 'root',    
    }

    file { '/etc/apt/oracle_vbox.asc' :
         source =>  "puppet:///modules/puppet_virtualbox/oracle_vbox.asc",
          owner => 'root',
          group => 'root',
        require => File["/etc/apt/sources.list.d/oracle.list"],
    }  
    
        
    # Install Oracle public key to apt - only if not already added
    
    exec { "add2apt-oracle-virtual-box-gpg-key" :
        command => '/usr/bin/apt-key add /etc/apt/oracle_vbox.asc',
         unless => "/usr/bin/apt-key finger | /bin/grep -w '7B0F AB3A 13B9 0743 5925  D9C9 5442 2A4B 98AB 5139'",
        require => File["/etc/apt/oracle_vbox.asc"],
    }

    # Run update apt to include Oracle repository - only on "new" virtualbox installs
    exec { "aptitude-update" :
            command => '/usr/bin/aptitude update',
            require => Exec["add2apt-oracle-virtual-box-gpg-key"],
          subscribe => File["/etc/apt/oracle_vbox.asc"],
        refreshonly => true,
    }
    
    
    # Install virtualbox from Oracle
    
    # Uncertain if this really is required...
    package  { "linux-headers-amd64":
        ensure => installed }
        
    package  { "dkms":
         ensure => installed,   
    }  
    
    package  { "virtualbox-4.2":
         ensure => installed,
        require => Exec["aptitude-update"],   
    }
    
}