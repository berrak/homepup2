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
	
	# apt runs Cron Daemon (07:15-07:45, crontab:daily) to download upgradable pkg's
    include admin_aptconf
	
    # this creates daily (07:15, crontab:daily) mailto to root unless on
	include puppet_logwatch
	
	# this creates daily (07:15, see crontab:daily) mailto if warnings unless
    include puppet_rkhunter
	
	# this creates daily (07:15, see crontab:daily) mailto if warnings unless 	
	include puppet_chkrootkit
	
	# cron/apt will upgrade 'security' once a day (will mail root about this)

    admin_cron::install { 'security' :
	                       command => '/root/bin/upgrade.security',
	                          hour => '10', minute => '0' }
			
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

    include puppet_agent

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