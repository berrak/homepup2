#
# Class to install package virtualbox
#
class puppet_virtualbox::install {

    
    if ! ( $::architecture == 'amd64' ) {
        fail("FAIL: The given host architecture ($::architecture) must be 'amd64' only.")
    }
    
    package  { "linux-headers-amd64":
        ensure => installed }
    
    package  { "virtualbox":
         ensure => installed,
        require => Package["linux-headers-amd64"],   
    }

}