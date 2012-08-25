##
## This class manage the setting in each node host file.
## 
##
class admin_hosts::config (
				$puppetserver_ip = '', $puppetserver_hostname = '',
				     $gateway_ip = '',      $gateway_hostname = '',
				        $smtp_ip = '',         $smtp_hostname = '',
) {

	
	# Facter node variables
	
	$mylocaldomain = $::domain
	$myhostname = $::hostname
	$myip = $::ipaddress
	
	
	# Add puppet server, gateway, smtp ip to default hosts file
	# but do not duplicate entries on these hosts. Assumes that,
	# puppetmaster, smtp and the gateway host are on different systems.
	
	
	case $myip {
    
        $puppetserver_ip: {
        
            file { '/etc/hosts' :
                content =>  template( 'admin_hosts/puppetserver.hosts.erb' ),
                  owner => 'root',
                  group => 'root',
                   mode => '0644',
            }
        
        }
	
        $gateway_ip: {
        
            file { '/etc/hosts' :
                content =>  template( 'admin_hosts/gateway.hosts.erb' ),
                  owner => 'root',
                  group => 'root',
                   mode => '0644',
            }

        }
		
        $smtp_ip: {
        
            file { '/etc/hosts' :
                content =>  template( 'admin_hosts/smtp.hosts.erb' ),
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
