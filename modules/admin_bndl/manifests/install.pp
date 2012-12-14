#
# Define a predefined package sets (bundles) to be
# to be installed on a node. Note: not for services.
#
# Sample usage:
#            admin_bndl::install { 'officeapps' : }
#            admin_bndl::install { 'developerapps': }
#
define admin_bndl::install {
  
    if ! ( $name in [ 'officeapps', 'cliadminapps', 'guiadminapps', 'developerapps', 'coresysapps', 'securityapps', 'nonfree' ]) {
        fail("Package bundle parameter ($name) not recognized!")
    }
  
  
    case $name {
    
        coresysapps : {
        
            # Non-default core system add-on applications
            
            package  { [ "firmware-linux-free" ] :
                ensure => installed }
        
        }
		
        nonfree : {
        
            # Non-free drivers. Note: require the 'non-free' repo
			# enabled on that host (see puppet module 'admin_aptconf').
            
            package  { [ "firmware-realtek" ] :
                ensure => installed }
        
        }		

        officeapps : {
        
            # Applications in addition to the default
            # Debian (wheezy) LXDE desktop installation.
            
            package  { [ "abiword", "evince", "icedove" ] :
                ensure => installed }
        
        }

        securityapps : {
        
            # Prevent disaster kind of related packages.
			# Note only pkgs that does not require lots of
			# tweaking of configuration files etc to work
			
            # gddrescue: backup image of disk despite disk/head errors
            
            package  { [ "gddrescue" ] :
                ensure => installed }
        
        }

        cliadminapps : {
        
            # Can be applied to desktops and non-public servers
            #--------------------------------------------------
            # lsof: list open files
            # psmisc: miscellaneous utilities that use the proc FS
			# lshw: system hardware information
			# telnet: telnet client
			# parted: partition table manipulator
			# wodim: command line CD/DVD writing tool
			# genisoimage: creates ISO-9660 CD-ROM filesystem images
			# ethtool: display or change Ethernet device settings
			# chkconfig: system tool to enable or disable system services
			# sysv-rc-conf: SysV init runlevel configuration tool for the terminal
			# debsums: verification of installed package files with MD5sums
			# bash-doc: documentation and examples for bash. 
			
        
            package  { [ "lsof", "psmisc", "lshw", "telnet", "parted", "wodim", "genisoimage" ] :
                ensure => installed }
			
			package  { [ "ethtool", "chkconfig", "sysv-rc-conf", "debsums", "bash-doc" ] :
                ensure => installed }
			
			
			# custom bash script to format usb flash drive to ext3
			file { "/root/bin/format.flash" :
					source => "puppet:///modules/admin_bndl/format.flash",
					 owner => 'root',
					 group => 'root',
					  mode => '0700',
			}
				 
			# custom bash script to append ssh identity keys to local network network hosts.
			file { "/root/bin/ssh.cpkey" :
					source => "puppet:///modules/admin_bndl/ssh.cpkey",
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
        
            # build-essential: various debian tools for the sw developer
			# perl-doc: use 'perldoc' to read extended module information 
			# cpanminus: get, unpack, build and install modules from CPAN
			# libmodule-starter-pbp-perl: 'Perl-Best-Practices' for Perl modules
			# diffuse: graphical tool for merging and comparing text files
          
	        package  { [ "build-essential", "perl-doc", "cpanminus", "libmodule-starter-pbp-perl", "diffuse" ]:
                 ensure => installed }
        
        
        }
        
        default: {}
        
    
    
    
    
    
    }

}