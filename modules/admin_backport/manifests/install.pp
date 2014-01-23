#
# Sample usage:
#            admin_backport::install { 'biwlwifi' : }
#
define admin_backport::install {
  

    case $name {
    
        bcm80211 : {
        
            # Install Broadcom Wifi support
			
			exec { "/usr/bin/apt-get install firmware-brcm80211/wheezy-backports" :
				refreshonly => true,
			}	   			
        
        }
		
        iwlwifi : {
        
            # Install Intel Centrino Advanced N6205 Wifi support
			
			exec { "/usr/bin/apt-get install firmware-brcm80211/wheezy-backports" :
				refreshonly => true,
			}	   			
        
        }		
		
        
        default: {
            fail("FAIL: Packageparameter ($name) not recognized!")
        }
        
    
    }

}