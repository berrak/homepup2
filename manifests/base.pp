#########################################
## (BASENODE) Included in every node
#########################################
node basenode {
	
	include puppet_utils
	include virtual_accounts
	
    include root_home
    include root_bashrc
	
	include admin_rsyslog
	include admin_logrotate
	
	include admin_cron
	
	# apt runs Cron Daemon (06:15-06:45, crontab:daily) to download upgradable pkg's
	# unless on a notebook, but anacron will run it when the system is available. 
    include admin_aptconf
	
    # this creates daily (06:15, crontab:daily) mailto to root unless on
	# a notebook, but anacron will run it when the system is available. 
	include puppet_logwatch
	
	# this creates daily (06:15, see crontab:daily) mailto if warnings unless
	# on a notebook, but anacron will run it when the system is available. 
    include puppet_rkhunter
	
	# this creates daily (06:15, see crontab:daily) mailto if warnings unless
	# on a notebook, but anacron will run it when the system is available. 	
	include puppet_chkrootkit
	
	# cron will upgrade security twice a day (will mail root about this)

    admin_cron::install { 'security' :
	                       command => '/root/bin/upgrade.security',
	                          hour => [ 10, 22 ], minute => '0' }
	
    class { admin_hosts::config :
		puppetserver_ip => '192.168.0.24', puppetserver_hostname => 'carbon',
		gateway_ip => '192.168.0.1', gateway_hostname => 'gondor',
		smtp_ip => '192.168.0.11', smtp_hostname => 'rohan' }
		
    include admin_pinpuppet2_7

    admin_bndl::install { 'securityapps' : }
    admin_bndl::install { 'coresysapps' : }
    admin_bndl::install { 'cliadminapps' : }
	
	# high memory usage during index rebuild - never allow install.
    admin_pkg::blacklist { 'apt-xapian-index' :}
	
	# If you don't use your ISP DNS ip's, OpenDNS addresses are used
    class { admin_resolvconf::config :
		dns_ip_1st => '195.67.199.18', dns_ip_2nd => '195.67.199.19' }
	
    # Disable ipv6 in kernel/grub and use the more text lines in console mode	
    class { admin_grub::install : defaultline => 'vga=791', appendline => 'true', ipv6 => 'false' }

}
#########################################
## (DEFAULT) for any new nodes - intially
#########################################
node default inherits basenode {

    include puppet_agent

    # following two classes assumes a single interface host 
	class { puppet_iptables::config : role => 'desktop' }
	
	class { puppet_network::interfaces :
		iface_zero => 'eth0', gateway_zero => '192.168.0.1', bcstnet_zero => '192.168.0.255',
		addfirewall => 'true' }

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