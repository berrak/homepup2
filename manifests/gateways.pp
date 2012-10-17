#########################################
## (GONDOR) gateway host/lan ntp server
#########################################
node 'gondor.home.tld' inherits basenode {

	include puppet_agent
    include puppet_tripwire
	include puppet_tiger
		
	# run tripwire check at noon and mailto root
    admin_cron::install { 'tripwire' :
	                       command => '/root/bin/tripwire.check',
	                          hour => '12', minute => '0' }		  				  
	
    # Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab::config : fstabhost => 'gondor' }
	
	admin_server::nohistory{ 'gondor' :}
		
    # load gateway firewall script
    class { puppet_iptables::config : role => 'gateway', hostnm => 'gondor' }
	
    class { puppet_network::interfaces :
		iface_zero => 'eth0', bcstnet_zero => '192.168.0.255',
		iface_one => 'eth1', bcstnet_one => '192.168.1.255',
		gateway_one => '192.168.1.1', addfirewall => 'true' }
	
	# lan ntp server provids time services to all lan clients
    class { 'puppet_ntp' : role => 'lanserver', peerntpip => '192.168.0.1' }
	
    puppet_postfix::install { 'mta' : ensure => installed, install_cyrus_sasl => 'false',
				mta_type => satellite, smtp_relayhost_ip => '192.168.0.11' }
	
    puppet_mutt::install { 'root': mailserver_hostname => 'rohan' }

}


##########################################
### (ASGARD) gateway host/apt repo server
##########################################
node 'asgard.home.tld' inherits basenode {

    include puppet_agent
	
    admin_server::nohistory{ 'gondor' :}
	
    # Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab::config : fstabhost => 'asgard' }

    # following two classes assumes a single interface host 
	class { puppet_iptables::config : role => 'default' }
	
	class { puppet_network::interfaces :
		iface_zero => 'eth0', gateway_zero => '192.168.0.1', bcstnet_zero => '192.168.0.255',
		addfirewall => 'true' }
		
    class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }	

    user_bashrc::config { 'bekr' : }

    # install local mail reader 
	puppet_mutt::install { 'bekr' : mailserver_hostname => 'rohan' }
    puppet_mutt::install { 'root': mailserver_hostname => 'rohan' }
	
	# always need mta
    puppet_postfix::install { 'mta' : ensure => installed, install_cyrus_sasl => 'false',
				mta_type => satellite, smtp_relayhost_ip => '192.168.0.11' }
				
}


###############################
## eof
###############################