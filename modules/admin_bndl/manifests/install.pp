#
# Define a predefined package sets (bundles) to be
# to be installed on a node. Note: not for services.
#
# Sample usage:
#            admin_bndl::install { 'officeapps' : }
#            admin_bndl::install { 'developerapps': }
#
define admin_bndl::install {
  
    if ! ( $name in [ 'officeapps', 'cliadminapps', 'guiadminapps', 'developerapps', 'coresysapps' ]) {
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
            
            package  { [ "abiword", "evince", "icedove", "libreoffice" ] :
                ensure => installed }
        
        }
        
        cliadminapps : {
        
            # Can be applied to desktops and non-public servers
            #--------------------------------------------------
            # lsof: list open files
            # psmisc: miscellaneous utilities that use the proc FS
            # gddrescue: backup image of disk despite disk/head errors
        
            package  { [ "lsof", "psmisc", "gddrescue" ] :
                 ensure => installed }
        
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