node basenode {

    include admin_home

    admin_bndl::install { 'cliadminapps' : }

}


node 'carbon.home.tld' inherits basenode {

	include puppet_master
    # puppet_devtools::tools { 'bekr' : }
	
    admin_bndl::install { 'guiadminapps' : }
    admin_bndl::install { 'officeapps' : }
    admin_bndl::install { 'developerapps' : }
	
    # This is the local client daemon ip address to query for time status
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }

}

node 'gondor.home.tld' inherits basenode {

	include puppet_agent
	
	# This is our lan ntp server ip, providing time services to all clients
    class { 'puppet_ntp' : role => 'lanserver', peerntpip => '192.168.0.1' }
    

}
