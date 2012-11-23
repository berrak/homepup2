#########################################
## (GONDOR) gateway host/lan ntp server
#########################################
node 'gondor.home.tld' inherits basenode {
	
    # assumes that all host lives in the same domain, otherwise specify it as a parameter
    class { admin_hosts::config :
        puppetserver_ip => '192.168.0.24', puppetserver_hostname => 'carbon',
        gateway_ip => '192.168.0.1', gateway_hostname => 'gondor',
        smtp_ip => '192.168.0.11', smtp_hostname => 'rohan' }
	
    include puppet_tripwire
	include puppet_tiger
    include admin_hardening
		
	# run tripwire checks 3 times per day and have tripwire mail to root (but not cron daemon)
    admin_cron::install { 'tripwire13' :
	    command => '/root/bin/tripwire.check > /dev/null 2>&1', hour => '13', minute => '0' }
    admin_cron::install { 'tripwire21' :
	    command => '/root/bin/tripwire.check > /dev/null 2>&1', hour => '21', minute => '0' }
    admin_cron::install { 'tripwire05' :
	    command => '/root/bin/tripwire.check > /dev/null 2>&1', hour => '5', minute => '0' }
	
    # Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab::config : fstabhost => 'gondor' }
		
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


###################################################################
### (ASGARD) gateway (between home.tld and sec.home.tld) host
###################################################################
node 'asgard.home.tld' inherits basenode {
    
	include puppet_tiger
    include admin_hardening
	
    # assumes that all host lives in the same domain, otherwise specify it as a parameter
    class { admin_hosts::config :
        puppetserver_ip => '192.168.0.24', puppetserver_hostname => 'carbon', puppetserver_domain => 'home.tld',
        gateway_ip => '192.168.0.1', gateway_hostname => 'gondor', gateway_domain => 'home.tld',
		gateway_subdomain => 'sec.home.tld',
        smtp_ip => '192.168.0.11', smtp_hostname => 'rohan', smtp_domain => 'home.tld' }
	
	# realtek nic firmware driver
    admin_bndl::install { 'nonfree' : }

	# needs accurate time (always)
    class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
    # Note: requires a copy of hosts 'fstab' file saved at puppetmaster.
    class { admin_fstab::config : fstabhost => 'asgard' }

    ## networking

    class { puppet_network::interfaces : interfaces => '2', hostnm => 'asgard',
                                                       addfirewall => 'true' }
		
    ## firewall (iptables)

    class { puppet_iptables::config : role => 'gateway', hostnm => 'asgard' }
	

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