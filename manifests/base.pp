#########################################
## (BASENODE) Included in every node
#########################################
node basenode {
	
	# this installs management of puppet itself 
	include puppetize
	
	include puppet_utils
	
    include root_home
    include root_bashrc
	
	include admin_rsyslog
	include admin_logrotate
	include admin_screen
	
	include admin_cron
    include admin_aptconf
	include admin_cronapt
	
	
	include puppet_logwatch
	include puppet_chkrootkit
				
    include admin_pinpuppet2_7

    admin_bndl::install { 'securityapps' : }
    admin_bndl::install { 'coresysapps' : }
    admin_bndl::install { 'cliadminapps' : }
	
	# high memory usage during index rebuild - never allow install.
    admin_pkg::blacklist { 'apt-xapian-index' :}
	
    class { admin_resolvconf::config : dns_provider => 'ispdns' }
	
    # Disable ipv6 in kernel/grub and use the more text lines in console mode	
    class { admin_grub::install : defaultline => 'vga=791', appendline => 'true', ipv6 => 'false' }

}
#########################################
## (DEFAULT) for any new nodes - intially
#########################################
node default inherits basenode {

    # assumes that all host lives in the same domain, otherwise specify it as a parameter
    class { admin_hosts::config :
        puppetserver_ip => '192.168.0.24', puppetserver_hostname => 'carbon',
        gateway_ip => '192.168.0.1', gateway_hostname => 'gondor',
        smtp_ip => '192.168.0.11', smtp_hostname => 'rohan' }


    # following two classes assumes a single interface host in 192.168.0.0/24 and eth0.
	class { puppet_iptables::config : role => 'default.server' }
    class { puppet_network::interfaces : broadcastnet => '192.168.0.0', defaultgateway => '192.168.0.1' }

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