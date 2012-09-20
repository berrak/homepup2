#########################################
## (BASENODE) Included in every node
#########################################
node basenode {
	
	include puppet_utils
	
    include root_home
    include root_bashrc
	
	include admin_rsyslog
	include admin_logrotate
	
	include admin_cron
	
	# apt runs Cron Daemon (06:15-06:45, crontab:daily) to download upgradable pkg's
	# unless on a notebook, but anacron will run it when the system is available. 
    include admin_aptconf
	
    # this creates daily (06:15, crontab:daily) mailto to root unless on
	# a notebook, but anacron will run it when the system is available. 
	include puppet_logwatch
	
	# this creates daily (06:15, see crontab:daily) mailto if warnings unless
	# on a notebook, but anacron will run it when the system is available. 
    include puppet_rkhunter
	
	# cron will upgrade security at midnight (will mail root about this)

    admin_cron::install { 'security' :
	                       command => '/root/bin/upgrade.security',
	                          hour => [ 10, 22 ], minute => '0' }
	
    class { admin_hosts::config :
		puppetserver_ip => '192.168.0.24', puppetserver_hostname => 'carbon',
		gateway_ip => '192.168.0.1', gateway_hostname => 'gondor',
		smtp_ip => '192.168.0.11', smtp_hostname => 'rohan' }
		
    include admin_pinpuppet2_7

    admin_bndl::install { 'securityapps' : }
    admin_bndl::install { 'coresysapps' : }
    admin_bndl::install { 'cliadminapps' : }
	
	# high memory usage during index rebuild - never allow install.
    admin_pkg::blacklist { 'apt-xapian-index' :}
	
	# If you don't use your ISP DNS ip's, OpenDNS addresses are used
    class { admin_resolvconf::config :
		dns_ip_1st => '195.67.199.18', dns_ip_2nd => '195.67.199.19' }

}
#########################################
## (CARBON) puppet master server
#########################################
node 'carbon.home.tld' inherits basenode {

    include puppet_master
	
	# Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab::config : fstabhost => 'carbon' }
		
    # this adds the firewall for puppetmaster.
    class { puppet_iptables::config : role => 'puppetmaster' }
	
	class { puppet_network::interfaces :
		iface_zero => 'eth0', gateway_zero => '192.168.0.1', bcstnet_zero => '192.168.0.255',
		addfirewall => 'true' }
	
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
	
    user_bashrc::config { 'bekr' : }
    puppet_devtools::tools { 'bekr' : }
	
    admin_bndl::install { 'guiadminapps' : }
    admin_bndl::install { 'officeapps' : }
    admin_bndl::install { 'developerapps' : }
	
    include puppet_cups
	
	# install local mail reader 
	puppet_mutt::install { 'bekr' : mailserver_hostname => 'rohan' }
    puppet_mutt::install { 'root': mailserver_hostname => 'rohan' }
	
    puppet_postfix::install { 'mta' : ensure => installed, install_cyrus_sasl => 'true',
				mta_type => satellite, smtp_relayhost_ip => '192.168.0.11' }
	
    # Disable ipv6 in kernel/grub
    include admin_ipv6_disable

}
#########################################
## (GONDOR) gateway host/lan ntp server
#########################################
node 'gondor.home.tld' inherits basenode {

	include puppet_agent
    include puppet_tripwire
		
	# run tripwire check at noon and mailto root
    admin_cron::install { 'tripwire' :
	                       command => '/root/bin/tripwire.check',
	                          hour => '12', minute => '0' }		  				  
	
    # Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab::config : fstabhost => 'gondor' }
	
	admin_server::timezone { 'CET' :}
	admin_server::nohistory{ 'gondor' :}
		
    # load gateway firewall script
    class { puppet_iptables::config : role => 'gateway' }
	
    class { puppet_network::interfaces :
		iface_zero => 'eth0', bcstnet_zero => '192.168.0.255',
		iface_one => 'eth1', bcstnet_one => '192.168.1.255',
		gateway_one => '192.168.1.1', addfirewall => 'true' }
	
	# lan ntp server provids time services to all lan clients
    class { 'puppet_ntp' : role => 'lanserver', peerntpip => '192.168.0.1' }
	
    puppet_postfix::install { 'mta' : ensure => installed, install_cyrus_sasl => 'true',
				mta_type => satellite, smtp_relayhost_ip => '192.168.0.11' }
	
    puppet_mutt::install { 'root': mailserver_hostname => 'rohan' }
	
    # Disable ipv6 in kernel/grub
    include admin_ipv6_disable

}
########################################
## (ROHAN) local intra-lan mail server
########################################
node 'rohan.home.tld' inherits basenode {

    include puppet_agent
	
    admin_server::timezone { 'CET' :}
	admin_server::nohistory { 'rohan' :}
	
    # Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab::config : fstabhost => 'rohan' }

    # load server firewall script
    class { puppet_iptables::config : role => 'server', hostnm => 'rohan' }
	 
	class { puppet_network::interfaces :
		iface_zero => 'eth0', gateway_zero => '192.168.0.1', bcstnet_zero => '192.168.0.255',
		addfirewall => 'true' }
		
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
	
    puppet_postfix::install { 'mta' :
						      ensure => installed,
				            mta_type => server,
				  install_cyrus_sasl => 'true',
		       server_root_mail_user => 'bekr',
				no_lan_outbound_mail => 'true' }
				
    class { puppet_dovecot_imap::install : ipv6 => 'no' }
	
    user_bashrc::config { 'bekr' : }
    user_bashrc::config { 'dakr' : }
	
    # install local mail reader, we need non-default .muttrc for mail server
    puppet_mutt::install { 'root': mailserver_hostname => 'rohan' }
	puppet_mutt::install { 'bekr': mailserver_hostname => 'rohan' }
    puppet_mutt::install { 'dakr': mailserver_hostname => 'rohan' }
	
    # Disable ipv6 in kernel/grub
    include admin_ipv6_disable

}
#########################################
## (MORDOR) developer host (laptop)
#########################################
node 'mordor.home.tld' inherits basenode {

    include puppet_agent
	
    # Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab::config : fstabhost => 'mordor' }

    # load desktop firewall script
    class { puppet_iptables::config : role => 'desktop' }
	 
	class { puppet_network::interfaces :
		iface_zero => 'eth0', gateway_zero => '192.168.0.1', bcstnet_zero => '192.168.0.255',
		addfirewall => 'true' }
		
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
	
    puppet_postfix::install { 'mta' : ensure => installed, install_cyrus_sasl => 'true',
				mta_type => satellite, smtp_relayhost_ip => '192.168.0.11' }		
	
    user_bashrc::config { 'bekr' : }
    puppet_devtools::tools { 'bekr' : }
	
    admin_bndl::install { 'guiadminapps' : }
    admin_bndl::install { 'officeapps' : }
    admin_bndl::install { 'developerapps' : }
	
    include puppet_cups
	
	# install local mail reader
    puppet_mutt::install { 'root': mailserver_hostname => 'rohan' }
	puppet_mutt::install { 'bekr': mailserver_hostname => 'rohan' }
	puppet_mutt::install { 'dakr': mailserver_hostname => 'rohan' }
	
    # Disable ipv6 in kernel/grub
    include admin_ipv6_disable
	

}
###############################
## eof
###############################