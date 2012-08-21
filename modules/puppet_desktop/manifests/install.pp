#
# Sets up the GUI environment on a minimal server install.
#
# Sample usage:
#            puppet_desktop::install { 'lxde' : }
#
define puppet_desktop::install {
  
    if ! ( $name in [ 'lxde' ]) {
        fail("FAIL: Desktop environment ($name) is not recognized!")
    }
  
    case $name {
    
        lxde : {
        
            # Debian package contains required LXDE applications
            
            package  { [ "lxde" ] :
                ensure => installed }
        
        }        
        
        default: {}
        
    }

}