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
	
    class { puppet_network::interfaces : interfaces => '2', hostnm => 'gondor',
                                                       addfirewall => 'true' }
	
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
	
	# realtek nic firmware driver
    admin_bndl::install { 'nonfree' : }
    admin_server::nohistory{ 'gondor' :}
	# needs accurate time (always)
    class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
    # Note: requires a copy of hosts 'fstab' file saved at puppetmaster.
    class { admin_fstab::config : fstabhost => 'asgard' }

    ## networking

    class { puppet_network::interfaces : interfaces => '2', hostnm => 'asgard',
                                                       addfirewall => 'false' }
		
    ## firewall (iptables)

	class { puppet_iptables::config : role => 'default' } 
	

    ## local users
	
    user_bashrc::config { 'bekr' : }
	puppet_mutt::install { 'bekr' : mailserver_hostname => 'rohan' }
    
	
	## mail options (always)
    puppet_postfix::install { 'mta' : ensure => installed, install_cyrus_sasl => 'false',
				mta_type => satellite, smtp_relayhost_ip => '192.168.0.11' }
    puppet_mutt::install { 'root': mailserver_hostname => 'rohan' }
				
}


###############################
## eof
###############################