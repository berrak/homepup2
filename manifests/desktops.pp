#########################################
## (MORDOR) developer host (laptop)
#########################################
node 'mordor.home.tld' inherits basenode {
	
    class { puppet_tiger::config : install_rec_tripwire => 'no' }
    include admin_hardening
    include puppet_rsync

    # assumes that all host lives in the same domain, otherwise specify it as a parameter
    class { admin_hosts::config :
        puppetserver_ip => '192.168.0.24', puppetserver_hostname => 'carbon',
        gateway_ip => '192.168.0.1', gateway_hostname => 'gondor',
        smtp_ip => '192.168.0.11', smtp_hostname => 'rohan' }

    # Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab::config : fstabhost => 'mordor' }

    # load desktop firewall script
    class { puppet_iptables::config : role => 'default.desktop' }
	 
    class { puppet_network::interfaces : broadcastnet => '192.168.0.0', defaultgateway => '192.168.0.1' }
		
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
	
    puppet_postfix::install { 'mta' : ensure => installed, install_cyrus_sasl => 'false',
				mta_type => satellite, smtp_relayhost_ip => '192.168.0.11' }		
	
	## users
	
    puppet_mutt::install { 'root': mailserver_hostname => 'rohan' }
	
    user_bashrc::config { 'bekr' : }
    puppet_mutt::install { 'bekr': mailserver_hostname => 'rohan' }
    puppet_devtools::tools { 'bekr' : }
	
	## enable nfs for user 'bekr' (really just creates the mount point in users' home)
    class { 'puppet_nfs4client::config' : user => 'bekr' }
	
	
    ## use this host for CPAN/perl projects
	puppet_komodoide6::install { 'bekr' : hostarch => 'i386' }
	puppet_gitclient::config { 'bekr': codehost => 'mordor' }
	
	
	## application bundles
	
    admin_bndl::install { 'guiadminapps' : }
    admin_bndl::install { 'officeapps' : }
    admin_bndl::install { 'developerapps' : }
	
    include puppet_cups
	

}
##########################################
## (DELL) NEW main developer host (laptop)
##########################################
node 'dell.home.tld' inherits basenode {
	
    class { puppet_tiger::config : install_rec_tripwire => 'no' }
    include admin_hardening
    include puppet_rsync

    # assumes that all host lives in the same domain, otherwise specify it as a parameter
    class { admin_hosts::config :
        puppetserver_ip => '192.168.0.24', puppetserver_hostname => 'carbon',
        gateway_ip => '192.168.0.1', gateway_hostname => 'gondor',
        smtp_ip => '192.168.0.11', smtp_hostname => 'rohan' }

    # Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab::config : fstabhost => 'dell' }

    # load desktop firewall script
    class { puppet_iptables::config : role => 'default.desktop' }
	 
    class { puppet_network::interfaces : broadcastnet => '192.168.0.0', defaultgateway => '192.168.0.1' }
		
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
	
    puppet_postfix::install { 'mta' : ensure => installed, install_cyrus_sasl => 'false',
				mta_type => satellite, smtp_relayhost_ip => '192.168.0.11' }		
	
    ## users customization
    
    user_bashrc::config { 'bekr' : }
    user_bashrc::config { 'jensen' : }    
    
	## users (mail)
	
    puppet_mutt::install { 'root': mailserver_hostname => 'rohan' }
    puppet_mutt::install { 'bekr': mailserver_hostname => 'rohan' }
	
	## enable nfs for user 'bekr' (really just creates the mount point in users' home)
    class { 'puppet_nfs4client::config' : user => 'bekr' }
	
	
    ## Skip now - need to find a Puppet way to install saved binaries/blobs...Dropbox?
    ## maybe do as with virtualbox install, i.e. repository at Dropbox?
	## puppet_komodoide6::install { 'bekr' : hostarch => 'amd64' }
    
    ## use this host for COBOL (or Python) projects
	puppet_gitclient::config { 'bekr': codehost => 'dell' }
	
	## Add Broadcom wifi firmware BCM802111 (Debian repo: backport)
	admin_backport::install { 'iwlwifi': }
	
	
	## application bundles
	
    admin_bndl::install { 'guiadminapps' : }
    admin_bndl::install { 'officeapps' : }
    admin_bndl::install { 'developerapps' : }
    admin_bndl::install { 'eclipseapps' : }	

    puppet_devtools::tools { 'bekr' : }    
    
    ## Simple COBOL IDE
    
    # need some some packages from testing for open-cobol-ide
    vb_add_aptrelease::config { 'testing' : }
    # this will install from ubuntu PPA repo and from debian testing
    include vb_opencobolide_ppa
    
    ## COBOL and SQL PostgreSQL development	
	
    # partial install of required debian pacakges for OCESQL pre-compiler
    include vb_ocesql      
    
	# Setup project structure for COBOL development (with Komodo IDE)
	
    ## set up COBOL project file structure (no spaces in names)
    
    class { puppet_komodo_devsetup::project :
      projectname => 'openjensen',
		 username => 'bekr',
        groupname => 'bekr',
    }
    
	# put makefiles in source development directories
	
    puppet_komodo_devsetup::make { 'src' :
     	projectname => 'openjensen',
		   username => 'bekr',
          groupname => 'bekr',
    }
    
    puppet_komodo_devsetup::make { 'lib' :
     	projectname => 'openjensen',
		   username => 'bekr',
          groupname => 'bekr',
    }

    puppet_komodo_devsetup::make { 'tools' :
     	projectname => 'openjensen',
		   username => 'bekr',
          groupname => 'bekr',
    }
	
    puppet_komodo_devsetup::make { 'html' :
     	projectname => 'openjensen',
		   username => 'bekr',
          groupname => 'bekr',
    }	
	
    puppet_komodo_devsetup::make { 'php' :
     	projectname => 'openjensen',
		   username => 'bekr',
          groupname => 'bekr',
    }		
    
    # Ensure daily cron backup
    
    puppet_komodo_devsetup::backup { 'bekr' : projectname => 'openjensen' }     	
    
    # PostgreSQL-9.1
    include vb_postgresql
    
	# Create database for the application and owner (option: 2nd databaseuser)
    vb_postgresql::create_database { 'openjensen' :
		databaseowner => 'jensen',
		databaseuser => '' }	
	
	
    ## Python development
     
    admin_bndl::install { 'pythonapps' : } 
     
    # Python Lint checker
    puppet_pylint::config { 'bekr' : }
    
    include puppet_cups
    
    # this is the latest sun/oracle version of VirtualBox - works out of the box :-)
    # include puppet_virtualbox
	
	## Java development
    admin_bndl::install { 'javaapps' : }
	
	
	## Package Java apps in debs
    admin_bndl::install { 'debpackaging' : }
	
	## Apache to serve statis html blog content
	## use apache2 prefork
    include vb_apache2
	
	 # Define a new Apache2 virtual host (docroot directory writable by group 'bekr')
    vb_apache2::vhost { 'www.debinix.tld' :
            priority => '001',
          devgroupid => 'bekr',
          execscript => 'none',
    }
    
    # Define content in /etc/hosts file. List ALL Apache VIRTUAL HOSTS here, declare always default www.default.tld.
    vb_hosts::config { 'bekr' : apache_virtual_host => [ "www.default.tld", "www.debinix.tld" ] }    
	
	

}
#########################################
## (SHIRE) developer host (desktop)
#########################################
node 'shire.home.tld' inherits basenode {

	include puppet_raid

    class { puppet_tiger::config : install_rec_tripwire => 'no' }
    include admin_hardening
	
	# this host acts as 'NFS data server' for all desktup hosts and needs backup (rsync)
	
	include puppet_rsync

    # assumes that all host lives in the same domain, otherwise specify it as a parameter
    class { admin_hosts::config :
        puppetserver_ip => '192.168.0.24', puppetserver_hostname => 'carbon',
        gateway_ip => '192.168.0.1', gateway_hostname => 'gondor',
        smtp_ip => '192.168.0.11', smtp_hostname => 'rohan' }

    # Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab::config : fstabhost => 'shire' }

    # load desktop firewall script
    class { puppet_iptables::config : role => 'default.desktop' }
	 
    class { puppet_network::interfaces : broadcastnet => '192.168.0.0', defaultgateway => '192.168.0.1' }
		
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
	
    puppet_postfix::install { 'mta' : ensure => installed, install_cyrus_sasl => 'false',
				mta_type => satellite, smtp_relayhost_ip => '192.168.0.11' }		
	
	## users
	
    puppet_mutt::install { 'root': mailserver_hostname => 'rohan' }
	
    user_bashrc::config { 'bekr' : }
    # user_bashrc::config { 'dakr' : }
	
	# must came after the user bashrc id defined (do not use until converted this ruby script  to perl)
	## puppet_git_md::config { 'bekr': }
	
    puppet_mutt::install { 'bekr': mailserver_hostname => 'rohan' }
    # puppet_mutt::install { 'dakr': mailserver_hostname => 'rohan' }
	
    puppet_devtools::tools { 'bekr' : }
	puppet_komodoide6::install { 'bekr' : hostarch => 'amd64' }
    
    # this is the latest sun/oracle version of VirtualBox (4.2) - works out of the box :-)
    include puppet_virtualbox
    
	## this (desktop-) host exports some 'home' sub-directories for user 'bekr'
    class { 'puppet_nfs4srv::config' : user => 'bekr' }
	
	## use this host for CPAN/perl projects
	
	puppet_gitclient::config { 'bekr': codehost => 'shire' }

	## application bundles
	
    admin_bndl::install { 'guiadminapps' : }
    admin_bndl::install { 'officeapps' : }
    admin_bndl::install { 'developerapps' : }
	
    include puppet_cups

}

###############################
## eof
###############################