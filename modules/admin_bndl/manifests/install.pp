#
# Define a predefined package sets (bundles) to be
# to be installed on a node. Note: not for services.
#
# Sample usage:
#            admin_bndl::install { 'officeapps' : }
#            admin_bndl::install { 'developerapps': }
#
define admin_bndl::install {
  

    case $name {
    
        coresysapps : {
        
            # Non-default core system add-on applications
            
            package  { [ "firmware-linux-free", "locales-all", "tree" ] :
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
            # Debian (wheezy) LXDE desktop installation
            
            package  { [ "abiword", "evince", "icedove",
			         "audacious", "guvcview", "uvcdynctrl" ] :
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
            # curl: transfer data with URL syntax
            # dnsutils: various client programs related to DNS
			# php5-cli: php5 scripting at the command line
			
        
            package  { [ "lsof", "psmisc", "lshw", "telnet", "parted", "wodim", "genisoimage", "curl" ] :
                ensure => installed }
			
			package  { [ "ethtool", "chkconfig", "sysv-rc-conf", "debsums", "bash-doc", "dnsutils", "php5-cli" ] :
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
			# diffuse: GUI tool for merging and comparing text files
          
	        package  { [ "build-essential", "diffuse"]:
                 ensure => installed }
        
		    ## Add some perl tools:
			# perltidy: perl script indenter and formatter
			# perl-doc: use 'perldoc' to read extended module information 
			# cpanminus: get, unpack, build and install modules from CPAN

	        package  { [ "perl-doc", "cpanminus", "perltidy" ]:
                 ensure => installed }
				 
			## Add CPAN lib/modules:
			# libmodule-starter-perl: simple starter kit for perl
			# libmodule-starter-pbp-perl: 'Perl-Best-Practices' for Perl modules
			# libtemplate-perl: the Template Toolkit processor
			# libtemplate-tiny-perl: Lightweigth implementation of Template Toolkit
			# libwww-mechanize-perl: automate intercation with websites
			
			package  { [ "libmodule-starter-perl", "libmodule-starter-pbp-perl", "libtemplate-perl", "libtemplate-tiny-perl", "libwww-mechanize-perl" ]:
                 ensure => installed }
			
			## Add CPAN test related modules (and required dependency modules):
			package  { [ "libtest-pod-perl", "libtest-pod-coverage-perl", "libtest-perl-critic-perl", "libtest-checkmanifest-perl" ]:
                ensure => installed }
		
		    ## Add more CPAN test modules
			package  { [ "libtest-expect-perl", "libtest-carp-perl", "libtest-spelling-perl", "libtest-www-mechanize-perl" ]:
                ensure => installed }
				
			## Add some logging and other modules
			package  { [ "liblog-log4perl-perl", "libconfig-gitlike-perl", "libxml-simple-perl" ]:
                ensure => installed }
		}
        
        pythonapps : {
        
            # pyflakes: passive checker of Python 2 and 3 programs
			# python-pyside: python bindings/interface to qt4
            # python-sphinx, sphinx-doc: python documentation generator
          
	        package  { [ "python-pyside", "pyflakes", "python-sphinx", "sphinx-doc" ]:
                 ensure => installed }
                 
        }
		
        eclipseapps : {
        
            # eclipse-platform: Eclipse platform 3.8 without development plugins
			# eclipse-cdt: C/C++ development tools
          
	        package  { [ "eclipse-platform", "eclipse-cdt" ]:
                 ensure => installed }
                 
        }
		
		
        javaapps : {
        
            # openjdk-7-jdk: Java developer kit (OpenJava)

          
	        package  { [ "openjdk-7-jdk" ]:
                 ensure => installed }
                 
        }
		
        debpackaging : {
        
            # debhelper: helper programs for debian/rules
			# javahelper: Create debs out of java programs and libs
			# dh-make: tool that converts source archives (tar.gz files)
			#          into Debian package source
			# devscripts: scripts to make the life of a Debian
			#             Package maintainer easier
			# fakeroot: tool for simulating superuser privileges
			# gnulib: GNU portability library
			# pandoc: general markup converter - converts markdown
			#         docs to HTML (real nice for longer general md-docs)
			# man2html-base: convert man to man format
			# groff:  groff printing system
			# ruby-ronn: markdown to man and html format (best man pages)
			
	        package  { [ "debhelper", "javahelper", "dh-make", "pandoc", "groff",
			    "man2html-base", "ruby-ronn", "devscripts", "fakeroot", "gnulib"]:
                 ensure => installed }
                 
        }		
		
        
        default: {
            fail("FAIL: Package bundle parameter ($name) not recognized!")
        }
        
    
    }

}