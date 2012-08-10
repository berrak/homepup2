##
## This class manage the setting in each nodes host file
##
class admin_hosts::config {

	include admin_hosts::params
	
	# Facter node variables
	
	$mylocaldomain = $::domain
	$myhostname = $::hostname
	$myip = $::ipaddress
	
	
	# Add puppet server and gateway ip to every hosts file
	
	$mypuppetserverip = $::serverip
	$mypuppetserverhostname = $::admin_hosts::params::mypuppetserver_hostname
	$mygatewayip = $::admin_hosts::params::gateway_ip
	
	
	# Since we do not wan't to duplicate host entries we have to test for
	# the puppetserver and the gateway first, otherwise deploy the default
	# host template. Assumes that puppetmsaster is NOT on the gateway host.
	
	case $myip {
    
        $mypuppetserverip: {
        
            file { '/etc/hosts' :
                content =>  template( 'admin_hosts/puppetserver.hosts.erb' ),
                  owner => 'root',
                  group => 'root',
                   mode => '0644',
            }
        
        }
	
        $mygatewayip: {
        
            file { '/etc/hosts' :
                content =>  template( 'admin_hosts/gateway.hosts.erb' ),
                  owner => 'root',
                  group => 'root',
                   mode => '0644',
            }

        }
        
        default: {
        
            file { '/etc/hosts' :
                content =>  template( 'admin_hosts/hosts.erb' ),
                  owner => 'root',
                  group => 'root',
                   mode => '0644',
            }
        }
	}
	
}
