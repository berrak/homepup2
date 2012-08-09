node basenode {

    include admin_home

    admin_bndl::install { 'cliadminapps' : }

}

## carbon is currently our puppetserver and
## the desktop working puppet test platform.
node 'carbon.home.tld' inherits basenode {

	include puppet_master
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

}

node 'gondor.home.tld' inherits basenode {

	include puppet_agent
    include puppet_tripwire
	include puppet_cups
		
	# this our gateway
    class { puppet_network::interfaces :
		iface_zero => 'eth0', gateway_zero => '192.168.0.1', bcstnet_zero => '192.168.0.255',
		iface_one => 'eth1', gateway_one => '192.168.1.1', bcstnet_one => '192.168.1.255',
		addfirewall => 'true' }
	
	# This is our lan ntp server, providing time services to all clients
    class { 'puppet_ntp' : role => 'lanserver', peerntpip => '192.168.0.1' }
    

}
