###############################
## Included in every node
###############################
node basenode {
	
	include puppet_utils
	
    include root_home
    include root_bashrc
	
    class { admin_hosts::config :
		puppetserver_ip => '192.168.0.24', puppetserver_hostname => 'carbon',
		gateway_ip => '192.168.0.1', gateway_hostname => 'gondor',
		smtp_ip => '192.168.0.11', smtp_hostname => 'rohan' }
		
	include admin_aptconf
    include admin_pinpuppet2_7

    admin_bndl::install { 'coresysapps' : }
    admin_bndl::install { 'cliadminapps' : }
	
	# high memory usage during index rebuild - never allow install.
    admin_pkg::blacklist { 'apt-xapian-index' :}
	
	# If you don't use your ISP DNS ip's, OpenDNS addresses are used
    class { admin_resolvconf::config :
		dns_ip_1st => '195.67.199.18', dns_ip_2nd => '195.67.199.19' }

}
###############################
## puppet master server
###############################
node 'carbon.home.tld' inherits basenode {

    include puppet_master
	
	# Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab : fstabhost => 'carbon' }
	
    include puppet_tripwire
	
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
	
    puppet_postfix::install { 'mta' : ensure => installed,
				mta_type => satellite, smtp_relayhost_ip => '192.168.0.11' }
	
    # Disable ipv6 in kernel/grub
    include admin_ipv6_disable

}
###############################
## gateway host/lan ntp server
###############################
node 'gondor.home.tld' inherits basenode {

	include puppet_agent
	
    include puppet_tripwire
	
    # Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab : fstabhost => 'gondor' }
	
	admin_server::timezone { 'CET' :}
	admin_server::nohistory{ 'gondor' :}
		
    # load gateway firewall script
    class { puppet_iptables::config : role => 'gateway' }
	
    class { puppet_network::interfaces :
		iface_zero => 'eth0', gateway_zero => '192.168.0.1', bcstnet_zero => '192.168.0.255',
		iface_one => 'eth1', gateway_one => '192.168.1.1', bcstnet_one => '192.168.1.255',
		addfirewall => 'true' }
	
	# lan ntp server provids time services to all lan clients
    class { 'puppet_ntp' : role => 'lanserver', peerntpip => '192.168.0.1' }
	
    puppet_postfix::install { 'mta' : ensure => installed,
				mta_type => satellite, smtp_relayhost_ip => '192.168.0.11' }
	
    # Disable ipv6 in kernel/grub
    include admin_ipv6_disable

}
###############################
## local intra-lan mail server
###############################
node 'rohan.home.tld' inherits basenode {

    include puppet_agent
	
    admin_server::timezone { 'CET' :}
	admin_server::nohistory { 'rohan' :}
	
    # Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab : fstabhost => 'rohan' }

    # load server firewall script
    class { puppet_iptables::config : role => 'server', hostnm => 'rohan' }
	 
	class { puppet_network::interfaces :
		iface_zero => 'eth0', gateway_zero => '192.168.0.1', bcstnet_zero => '192.168.0.255',
		addfirewall => 'true' }
		
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
	
    puppet_postfix::install { 'mta' :
						      ensure => installed,
				            mta_type => server,
				      root_mail_user => 'bekr',
				no_lan_outbound_mail => 'true' }
				
    class { puppet_dovecot_imap::install : ipv6 => 'no' }
	
    user_bashrc::config { 'bekr' : }
    user_bashrc::config { 'dakr' : }
	
    # Disable ipv6 in kernel/grub
    include admin_ipv6_disable

}
###############################
## developer host (laptop)
###############################
node 'mordor.home.tld' inherits basenode {

    include puppet_agent
	
    # Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab : fstabhost => 'mordor' }

    # load desktop firewall script
    class { puppet_iptables::config : role => 'desktop' }
	 
	class { puppet_network::interfaces :
		iface_zero => 'eth0', gateway_zero => '192.168.0.1', bcstnet_zero => '192.168.0.255',
		addfirewall => 'true' }
		
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
	
    puppet_postfix::install { 'mta' : ensure => installed,
				mta_type => satellite, smtp_relayhost_ip => '192.168.0.11' }		
	
    user_bashrc::config { 'bekr' : }
    puppet_devtools::tools { 'bekr' : }
	
    admin_bndl::install { 'guiadminapps' : }
    admin_bndl::install { 'officeapps' : }
    admin_bndl::install { 'developerapps' : }
	
    include puppet_cups
	
    # Disable ipv6 in kernel/grub
    include admin_ipv6_disable
	

}
###############################
## eof
###############################