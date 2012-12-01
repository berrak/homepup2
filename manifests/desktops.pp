#########################################
## (MORDOR) developer host (laptop)
#########################################
node 'mordor.home.tld' inherits basenode {
	
    include puppet_tiger
    include admin_hardening
    include puppet_rsync

    # assumes that all host lives in the same domain, otherwise specify it as a parameter
    class { admin_hosts::config :
        puppetserver_ip => '192.168.0.24', puppetserver_hostname => 'carbon',
        gateway_ip => '192.168.0.1', gateway_hostname => 'gondor',
        smtp_ip => '192.168.0.11', smtp_hostname => 'rohan' }

    # Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab::config : fstabhost => 'mordor' }

    # load desktop firewall script
    class { puppet_iptables::config : role => 'default.desktop' }
	 
    class { puppet_network::interfaces : broadcastnet => '192.168.0.0', defaultgateway => '192.168.0.1' }
		
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
	
    puppet_postfix::install { 'mta' : ensure => installed, install_cyrus_sasl => 'false',
				mta_type => satellite, smtp_relayhost_ip => '192.168.0.11' }		
	
	## users
	
    puppet_mutt::install { 'root': mailserver_hostname => 'rohan' }
	
    user_bashrc::config { 'bekr' : }
    puppet_mutt::install { 'bekr': mailserver_hostname => 'rohan' }
    puppet_devtools::tools { 'bekr' : }
	
	## enable nfs for user 'bekr' (really just creates the mount point in users' home)
    class { 'puppet_nfs4client::config' : user => 'bekr' }
	
	
    ## use this host for CPAN/perl projects
	
	puppet_git::config { 'bekr': codehost => 'mordor' }
	
	
	## application bundles
	
    admin_bndl::install { 'guiadminapps' : }
    admin_bndl::install { 'officeapps' : }
    admin_bndl::install { 'developerapps' : }
	
    include puppet_cups
	

}
#########################################
## (SHIRE) developer host (desktop)
#########################################
node 'shire.home.tld' inherits basenode {

	include puppet_raid

    include puppet_tiger
    include admin_hardening
	
	# this host acts as 'NFS data server' for all desktup hosts and needs backup (rsync)
	
	include puppet_rsync

    # assumes that all host lives in the same domain, otherwise specify it as a parameter
    class { admin_hosts::config :
        puppetserver_ip => '192.168.0.24', puppetserver_hostname => 'carbon',
        gateway_ip => '192.168.0.1', gateway_hostname => 'gondor',
        smtp_ip => '192.168.0.11', smtp_hostname => 'rohan' }

    # Note: requires a copy of hosts 'fstab' file at puppetmaster.
    class { admin_fstab::config : fstabhost => 'shire' }

    # load desktop firewall script
    class { puppet_iptables::config : role => 'default.desktop' }
	 
    class { puppet_network::interfaces : broadcastnet => '192.168.0.0', defaultgateway => '192.168.0.1' }
		
	class { 'puppet_ntp' : role => 'lanclient', peerntpip => $ipaddress }
	
    puppet_postfix::install { 'mta' : ensure => installed, install_cyrus_sasl => 'false',
				mta_type => satellite, smtp_relayhost_ip => '192.168.0.11' }		
	
	## users
	
    puppet_mutt::install { 'root': mailserver_hostname => 'rohan' }
	
    user_bashrc::config { 'bekr' : }
    user_bashrc::config { 'dakr' : }
	
    puppet_mutt::install { 'bekr': mailserver_hostname => 'rohan' }
    puppet_mutt::install { 'dakr': mailserver_hostname => 'rohan' }
	
    puppet_devtools::tools { 'bekr' : }
	
	## this (desktop-) host exports some 'home' sub-directories for user 'bekr'
    class { 'puppet_nfs4srv::config' : user => 'bekr' }
	
	## use this host for CPAN/perl projects
	
	puppet_git::config { 'bekr': codehost => 'shire' }

	## application bundles
	
    admin_bndl::install { 'guiadminapps' : }
    admin_bndl::install { 'officeapps' : }
    admin_bndl::install { 'developerapps' : }
	
    include puppet_cups

}

###############################
## eof
###############################