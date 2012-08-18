node basenode {

    include puppet_utils
	
    include root_home
    include root_bashrc
	
    include admin_hosts
	include admin_aptconf
    include admin_pinpuppet2_7

    admin_bndl::install { 'coresysapps' : }
    admin_bndl::install { 'cliadminapps' : }
	
	# If you don't use your ISP DNS ip's, OpenDNS addresses are used
    class { admin_resolvconf::config :
		dns_ip_1st => '195.67.199.18', dns_ip_2nd => '195.67.199.19' }

}

## 'carbon' is currently our puppetserver and the
## working puppet agent (development desktop)
node 'carbon.home.tld' inherits basenode {

	# Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab : fstabhost => 'carbon' }
	
	include puppet_master

    include puppet_tripwire
    include puppet_cups
	
	user_bashrc::config { 'bekr' : }
    puppet_devtools::tools { 'bekr' : }
	
    admin_bndl::install { 'guiadminapps' : }
    admin_bndl::install { 'officeapps' : }
    admin_bndl::install { 'developerapps' : }
	
    # this adds the default desktop firewall.
    include puppet_iptables
	
	class { puppet_network::interfaces :
		iface_zero => 'eth0', gateway_zero => '192.168.0.1', bcstnet_zero => '192.168.0.255',
		addfirewall => 'true' }
	
    # This is the local node client daemon to query for time status
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
	
    # Disable ipv6 in kernel/grub - this will reboot host when ensure changes
    class { admin_ipv6 : ensure => 'absent' }

}

# home.tld --> 'gondor-gw' --> dmz.tld --> firewall --> internet
node 'gondor.home.tld' inherits basenode {

	include puppet_agent
    include puppet_tripwire
	
    # Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab : fstabhost => 'gondor' }
	
	admin_server::timezone { 'CET' :}
	admin_server::nohistory{ 'gondor' :}
		
	# this adds the gateway host firewall
    include puppet_iptables
	
    class { puppet_network::interfaces :
		iface_zero => 'eth0', gateway_zero => '192.168.0.1', bcstnet_zero => '192.168.0.255',
		iface_one => 'eth1', gateway_one => '192.168.1.1', bcstnet_one => '192.168.1.255',
		addfirewall => 'true' }
	
	# and is the local lan ntp server, providing time services to all lan clients
    class { 'puppet_ntp' : role => 'lanserver', peerntpip => '192.168.0.1' }
	
    # Disable ipv6 in kernel/grub - this will reboot host when ensure changes
    class { admin_ipv6 : ensure => 'absent' }

}

# local mail server
node 'rohan.home.tld' inherits basenode {

	user_bashrc::config { 'bekr' : }
	
    include puppet_agent
	
    admin_server::timezone { 'CET' :}
	admin_server::nohistory { 'rohan' :}
	
    # Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab : fstabhost => 'rohan' }

    # this adds the default desktop firewall to rohan (for now. Todo: customize for rohan).
	include puppet_iptables

	class { puppet_network::interfaces :
		iface_zero => 'eth0', gateway_zero => '192.168.0.1', bcstnet_zero => '192.168.0.255',
		addfirewall => 'true' }
		
    # This is the local node client daemon to query for time status
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
	
    # Disable ipv6 in kernel/grub - this will reboot host when ensure changes
    class { admin_ipv6 : ensure => 'absent' }

}
