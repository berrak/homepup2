#########################################
## (CARBON) puppet master server
#########################################
node 'carbon.home.tld' inherits basenode {

    include puppet_master
	include puppet_tiger
	
	# Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab::config : fstabhost => 'carbon' }
		
    # this adds the firewall for puppetmaster.
    class { puppet_iptables::config : role => 'puppetmaster', hostnm => 'carbon' }
	
    class { puppet_network::interfaces : broadcastnet => '192.168.0.0', defaultgateway => '192.168.0.1' }
	
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
	
    user_bashrc::config { 'bekr' : }
    puppet_devtools::tools { 'bekr' : }
	
    puppet_git::config { 'bekr': codehost => 'carbon' }
	
    admin_bndl::install { 'guiadminapps' : }
    admin_bndl::install { 'officeapps' : }
    admin_bndl::install { 'developerapps' : }
	
    include puppet_cups
	
	# install local mail reader 
	puppet_mutt::install { 'bekr' : mailserver_hostname => 'rohan' }
    puppet_mutt::install { 'root': mailserver_hostname => 'rohan' }
	
    puppet_postfix::install { 'mta' : ensure => installed, install_cyrus_sasl => 'false',
				mta_type => satellite, smtp_relayhost_ip => '192.168.0.11' }

}

########################################
## (ROHAN) local intra-lan mail server
########################################
node 'rohan.home.tld' inherits basenode {

    include puppet_agent
	
	admin_server::nohistory { 'rohan' :}
	
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
				
    class { puppet_dovecot_imap::install : ipv6 => 'no' }
	
	## users
	
    puppet_mutt::install { 'root': mailserver_hostname => 'rohan' }
	
    user_bashrc::config { 'bekr' : }
    puppet_mutt::install { 'bekr': mailserver_hostname => 'rohan' }
	
    user_bashrc::config { 'dakr' : }
    puppet_mutt::install { 'dakr': mailserver_hostname => 'rohan' }

}

#########################################
## (VALHALL TEST SERVER)
#########################################
node 'valhall.home.tld' inherits basenode {

    include puppet_agent
    
	## network and default services
	
    class { puppet_network::interfaces : broadcastnet => '192.168.2.0', defaultgateway => '192.168.2.1' }
    class { puppet_iptables::config : role => 'default', inet => '192.168.2.0/24' }
	
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
	
	## security related
	
    include puppet_tiger
	include admin_hardening
    
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