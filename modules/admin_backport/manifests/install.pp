#
# Sample usage:
#            admin_backport::install { 'bcm80211' : }
#
define admin_backport::install {
  

    case $name {
    
        bcm80211 : {
        
            # Install Broadcom Wifi support
			
			exec { "/usr/bin/apt-get install firmware-brcm80211/wheezy-backports" :
				refreshonly => true,
			}	   			
        
        }
        
        default: {
            fail("FAIL: Packageparameter ($name) not recognized!")
        }
        
    
    }

}