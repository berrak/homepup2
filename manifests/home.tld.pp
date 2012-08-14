node basenode {

    include admin_home
    include admin_hosts
	include admin_fstab
	include admin_aptconf
	include admin_bashrc
    include admin_pkgvers
	include admin_utils
	
	include puppet_iptables
	
	# If you don't use your ISP DNS ip's, OpenDNS addresses are used
    class { admin_resolvconf::config :
		dns_ip_1st => '195.67.199.18', dns_ip_2nd => '195.67.199.19' }
	
    admin_bndl::install { 'cliadminapps' : }

}

## 'carbon' is currently our puppetserver and the
## working puppet agent (development desktop.
node 'carbon.home.tld' inherits basenode {

	include puppet_master
	
	user_bashrc::config { 'bekr' : }
    puppet_devtools::tools { 'bekr' : }
	
    admin_bndl::install { 'guiadminapps' : }
    admin_bndl::install { 'officeapps' : }
    admin_bndl::install { 'developerapps' : }
	
	class { puppet_network::interfaces :
		iface_zero => 'eth0', gateway_zero => '192.168.0.1', bcstnet_zero => '192.168.0.255',
		addfirewall => 'true' }
	
    # This is the local node client daemon to query for time status
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
	
    include puppet_tripwire
    include puppet_cups

}

# home.tld --> 'gondor-gw' --> dmz.tld --> firewall --> internet
node 'gondor.home.tld' inherits basenode {

	include puppet_agent
    include puppet_tripwire
	
	admin_server::timezone { 'CET' :}
	admin_server::nohistory{ 'gondor' :}
		
	# this is our gateway host
    class { puppet_network::interfaces :
		iface_zero => 'eth0', gateway_zero => '192.168.0.1', bcstnet_zero => '192.168.0.255',
		iface_one => 'eth1', gateway_one => '192.168.1.1', bcstnet_one => '192.168.1.255',
		addfirewall => 'true' }
	
	# and is the local lan ntp server, providing time services to all lan clients
    class { 'puppet_ntp' : role => 'lanserver', peerntpip => '192.168.0.1' }
    

}
