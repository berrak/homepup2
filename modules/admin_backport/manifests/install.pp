#
# Sample usage:
#            admin_backport::install { 'bcm80211' : }
#
define admin_backport::install {
  

    case $name {
    
        bcm80211 : {
        
            # Install Broadcom Wifi support
            
            package  { [ "firmware-brcm80211"] :
                ensure => installed }
        
        }
        
        default: {
            fail("FAIL: Packageparameter ($name) not recognized!")
        }
        
    
    }

}