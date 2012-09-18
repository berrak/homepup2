#
# Define a predefined package sets (bundles) to be
# to be installed on a node. Note: not for services.
#
# Sample usage:
#            admin_bndl::install { 'officeapps' : }
#            admin_bndl::install { 'developerapps': }
#
define admin_bndl::install {
  
    if ! ( $name in [ 'officeapps', 'cliadminapps', 'guiadminapps', 'developerapps', 'coresysapps', 'securityapps' ]) {
        fail("Package bundle parameter ($name) not recognized!")
    }
  
  
    case $name {
    
        coresysapps : {
        
            # Non-default core system add-on applications
            
            package  { [ "firmware-linux-free" ] :
                ensure => installed }
        
        }        

        officeapps : {
        
            # Applications in addition to the default
            # Debian (wheezy) LXDE desktop installation.
            
            package  { [ "abiword", "evince", "icedove" ] :
                ensure => installed }
        
        }

        securityapps : {
        
            # Security related packages
			# rkhunter: scans systems for rootkits, backdoors, sniffers and exploits. 
            
            package  { [ "rkhunter" ] :
                ensure => installed }
        
        }

        cliadminapps : {
        
            # Can be applied to desktops and non-public servers
            #--------------------------------------------------
            # lsof: list open files
            # psmisc: miscellaneous utilities that use the proc FS
            # gddrescue: backup image of disk despite disk/head errors
			# lshw: system hardware information
			# telnet: telnet client
			# parted: partition table manipulator
			# wodim: command line CD/DVD writing tool
			# genisoimage: creates ISO-9660 CD-ROM filesystem images
        
            package  { [ "lsof", "psmisc", "gddrescue", "lshw", "telnet", "parted", "wodim", "genisoimage" ] :
                ensure => installed }
				 
			file { "/root/bin/format.usbflash" :
					source => "puppet:///modules/admin_bndl/format.usbflash",
					 owner => 'root',
					 group => 'root',
					  mode => '0700',
			}
				 
				 
        
        }
        
        guiadminapps : {
        
            # glogg: system logg/filter qt4 viewer analyzing log files
            # xclip: command line interface to X selections
        
            package  { [ "glogg", "xclip" ] :
                 ensure => installed }
        }
        
        
        developerapps : {
        
            # tools for the developer
          
	        package  { [ "build-essential", "anjuta" ]:
                 ensure => installed }
        
        
        }
        
        default: {}
        
    
    
    
    
    
    }

}