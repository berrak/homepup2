#########################################
## (CARBON) puppet client/master host
#########################################
node 'nodecarbon.home.tld' inherits basenode {
    
    class { puppet_tiger::config : install_rec_tripwire => 'no' }
    include admin_hardening
    
    # assumes that all host lives in the same domain, otherwise specify it as a parameter
    class { admin_hosts::config :
    puppetserver_ip => '192.168.0.24', puppetserver_hostname => 'carbon',
    gateway_ip => '192.168.0.1', gateway_hostname => 'gondor',
    smtp_ip => '192.168.0.11', smtp_hostname => 'rohan' }
    
    # Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab::config : fstabhost => 'carbon' }
        
    # this adds the firewall for puppetmaster.
    class { puppet_iptables::config : role => 'puppetmaster', hostnm => 'carbon' }
    
    class { puppet_network::interfaces : broadcastnet => '192.168.0.0', defaultgateway => '192.168.0.1' }
    
    class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
    
    ## users
    
    puppet_devtools::tools { 'bekr' : }
    
    user_bashrc::config { 'bekr' : }
    
    # must came after the user bashrc id defined (do not use until converted this ruby script  to perl)
    ## puppet_git_md::config { 'bekr': }
    
    ## enable nfs for user 'bekr' (really just creates the mount point in users' home)
    class { 'puppet_nfs4client::config' : user => 'bekr' }	
    
    ## use this host for puppet projects
    
    puppet_komodoide6::install { 'bekr' : hostarch => 'i386' }
    puppet_gitclient::config { 'bekr': codehost => 'carbon' }
    
    admin_bndl::install { 'guiadminapps' : }
    admin_bndl::install { 'officeapps' : }
    admin_bndl::install { 'developerapps' : }
    
    
    include puppet_cups
    
    # install local mail reader 
    puppet_mutt::install { 'bekr' : mailserver_hostname => 'rohan' }
    puppet_mutt::install { 'root': mailserver_hostname => 'rohan' }
    
    puppet_postfix::install { 'mta' : ensure => installed, install_cyrus_sasl => 'false',
                mta_type => satellite, smtp_relayhost_ip => '192.168.0.11' }
        
    #temporary removed apache from this host			
    # include puppet_apache
	
	# Manage all other local servers with cluster ssh
	class { puppet_cluster_ssh::config : user => 'bekr' }
	
}

########################################
## (ROHAN) local intra-lan mail server
########################################
node 'rohan.home.tld' inherits basenode {

    # assumes that all host lives in the same domain, otherwise specify it as a parameter
    class { admin_hosts::config :
        puppetserver_ip => '192.168.0.24', puppetserver_hostname => 'carbon',
        gateway_ip => '192.168.0.1', gateway_hostname => 'gondor',
        smtp_ip => '192.168.0.11', smtp_hostname => 'rohan' }
	
    # Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab::config : fstabhost => 'rohan' }

    # load server firewall script
    class { puppet_iptables::config : role => 'mailserver', hostnm => 'rohan' }
	 
    class { puppet_network::interfaces : broadcastnet => '192.168.0.0', defaultgateway => '192.168.0.1' }
		
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
	
	## mail options
	
    puppet_postfix::install { 'mta' : ensure => installed, mta_type => server,
				install_cyrus_sasl => 'false', procmail_lda => 'true',
		        server_root_mail_user => 'bekr', no_lan_outbound_mail => 'true' }
			
	# add alternative local delivery agent (LDA) to filter mails into folders etc			
    include puppet_procmail
		
	# SKIP complains of missing /pem file		
    # class { puppet_dovecot_imap::install : ipv6 => 'yes' }
	
	## users
	
    puppet_mutt::install { 'root': mailserver_hostname => 'rohan' }
	
    user_bashrc::config { 'bekr' : }
    puppet_mutt::install { 'bekr': mailserver_hostname => 'rohan' }
	
    user_bashrc::config { 'dakr' : }
    puppet_mutt::install { 'dakr': mailserver_hostname => 'rohan' }

}

##########################################################
## (VALHALL TEST SERVER) - local test server
##########################################################
node 'valhall.home.tld' inherits basenode {

    ## assumes that all host lives in the same domain, otherwise specify it as a parameter
    class { admin_hosts::config :
        puppetserver_ip => '192.168.0.24', puppetserver_hostname => 'carbon',
        gateway_ip => '192.168.0.1', gateway_hostname => 'gondor',
        smtp_ip => '192.168.0.11', smtp_hostname => 'rohan' }
			
    ## git project depot for various git developer groups
	
    puppet_gitserver::config { 'git1_project1': gitgrp => 'git1', projectname => 'project1'}
	
	puppet_gitserver::config { 'git2_project1': gitgrp => 'git2',projectname => 'project1'}
    puppet_gitserver::config { 'git2_project2': gitgrp => 'git2',projectname => 'project2'}
    puppet_gitserver::config { 'git2_project3': gitgrp => 'git2',projectname => 'project3'}
	
    puppet_gitserver::config { 'git3_project1': gitgrp => 'git3',projectname => 'project1'}

    
	## network and default services
	
    class { puppet_network::interfaces : broadcastnet => '192.168.0.0', defaultgateway => '192.168.0.1' }
	
    class { puppet_iptables::config : role => 'default.server', inet => '192.168.0.0/24' }
	
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
	    
	## additional users other than root
    user_bashrc::config { 'bekr' : }
	
	## mail for all users
    puppet_postfix::install { 'mta' : ensure => installed, install_cyrus_sasl => 'false',
				mta_type => satellite, smtp_relayhost_ip => '192.168.0.11' }
    puppet_mutt::install { 'root': mailserver_hostname => 'rohan' }			
    puppet_mutt::install { 'bekr': mailserver_hostname => 'rohan' }			

}

##########################################################
## (NAGIOS SERVER)
##########################################################
node 'nagios.home.tld' inherits basenode {
    
    ## assumes that all host lives in the same domain, otherwise specify it as a parameter
    class { admin_hosts::config :
        puppetserver_ip => '192.168.0.24', puppetserver_hostname => 'carbon',
        gateway_ip => '192.168.0.1', gateway_hostname => 'gondor',
        smtp_ip => '192.168.0.11', smtp_hostname => 'rohan' }
		
	## network and default services
	
    class { puppet_network::interfaces : broadcastnet => '192.168.0.0', defaultgateway => '192.168.0.1' }
	
    class { puppet_iptables::config : role => 'default.server', inet => '192.168.0.0/24' }
	
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
	    
	## additional users other than root
    user_bashrc::config { 'bekr' : }
	
	## mail for all users
    puppet_postfix::install { 'mta' : ensure => installed, install_cyrus_sasl => 'false',
				mta_type => satellite, smtp_relayhost_ip => '192.168.0.11' }
    puppet_mutt::install { 'root': mailserver_hostname => 'rohan' }			
    puppet_mutt::install { 'bekr': mailserver_hostname => 'rohan' }			

}

##########################################################
## (WARP) - Fileserver: In sub domain: sec.home.tld
##########################################################
node 'warp.sec.home.tld' inherits basenode {
	
	# Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab::config : fstabhost => 'warp' }


    # if this host is not in the same domain as servers, specify it as a parameter
    class { admin_hosts::config :
        puppetserver_ip => '192.168.0.24', puppetserver_hostname => 'carbon', puppetserver_domain => 'home.tld',
        gateway_ip => '192.168.0.1', gateway_hostname => 'gondor', gateway_domain => 'home.tld',
        smtp_ip => '192.168.0.11', smtp_hostname => 'rohan', smtp_domain => 'home.tld',
		gateway_security_ip => '192.168.2.1', gateway_security_hostname => 'asgard', gateway_security_domain => 'sec.home.tld' }
    
	## network and default services
	
    class { puppet_network::interfaces : broadcastnet => '192.168.2.0', defaultgateway => '192.168.2.1' }
	
    class { puppet_iptables::config : role => 'fileserver', hostnm => 'warp' }
	
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
	
	## security related
	
    class { puppet_tiger::config : install_rec_tripwire => 'no' }
	include admin_hardening

	## git repository depot (add project list and 'gitx' access groups)
	## Note that group e.g. 'git1' must be created manually before access
	## is possible by admin, with '# adduser --shell /usr/bin/git-shell git1'
	## Note that the resource, i.e. first parameter below must be unique.
	
	puppet_gitserver::config { 'git1_Filter-Heredoc': gitgrp => 'git1',projectname => 'Filter-Heredoc'}
    puppet_gitserver::config { 'git1_cpan-project-msk': gitgrp => 'git1',projectname => 'Module-Starterkit'}
    puppet_gitserver::config { 'git1_config': gitgrp => 'git1',projectname => 'Config-XML-INI'}
	
    puppet_gitserver::config { 'git2_branch-model': gitgrp => 'git2',projectname => 'My-Module'}

	
	## backup server
	
	include puppet_rsync
	
	## central loghost 
	
	include puppet_logcheck
    
	## additional users other than root
	
    user_bashrc::config { 'bekr' : }
	
	## mail for all users
	
    puppet_postfix::install { 'mta' : ensure => installed, install_cyrus_sasl => 'false',
				mta_type => satellite, smtp_relayhost_ip => '192.168.0.11' }
    puppet_mutt::install { 'root': mailserver_hostname => 'rohan' }			
    puppet_mutt::install { 'bekr': mailserver_hostname => 'rohan' }			

}

###############################
## eof
###############################