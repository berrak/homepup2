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

## puppet master server
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
	
    # Disable ipv6 in kernel/grub - this will reboot host when $ensure changes
    class { admin_ipv6 : ensure => 'absent' }

}

## gateway host/lan ntp server
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
	
    # Disable ipv6 in kernel/grub - this will reboot host when $ensure changes
    class { admin_ipv6 : ensure => 'absent' }

}

## local intra-lan mail server
node 'rohan.home.tld' inherits basenode {

    include puppet_agent
	
    admin_server::timezone { 'CET' :}
	admin_server::nohistory { 'rohan' :}
	
    # Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab : fstabhost => 'rohan' }

    # load server firewall script
    class { puppet_iptables::config : role => 'server' }
	 
	class { puppet_network::interfaces :
		iface_zero => 'eth0', gateway_zero => '192.168.0.1', bcstnet_zero => '192.168.0.255',
		addfirewall => 'true' }
		
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
	
    puppet_postfix::install { 'mta' : ensure => installed, mta_type => server }
	
    user_bashrc::config { 'bekr' : }
	
    # Disable ipv6 in kernel/grub - this will reboot host when $ensure changes
    class { admin_ipv6 : ensure => 'absent' }

}

## developer host (laptop)
node 'mordor.home.tld' inherits basenode {

    include puppet_agent
	
    # Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab : fstabhost => 'mordor' }

    # load server firewall script
    class { puppet_iptables::config : role => 'desktop' }
	 
	class { puppet_network::interfaces :
		iface_zero => 'eth0', gateway_zero => '192.168.0.1', bcstnet_zero => '192.168.0.255',
		addfirewall => 'true' }
		
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
	
    puppet_postfix::install { 'mta' : ensure => installed, mta_type => satellite }
	
    user_bashrc::config { 'bekr' : }
	
    # Disable ipv6 in kernel/grub - this will reboot host when $ensure changes
    class { admin_ipv6 : ensure => 'absent' }
	
	puppet_desktop::install { 'lxde' : }

}
