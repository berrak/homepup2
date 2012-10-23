##
## This class manage the setting in each node host file.
## 
##
class admin_hosts::config (
				$puppetserver_ip = '', $puppetserver_hostname = '', $puppetserver_domain = '',
				     $gateway_ip = '',      $gateway_hostname = '', $gateway_domain = '',
				        $smtp_ip = '',         $smtp_hostname = '', $smtp_domain = '',
) {

	
	# Facter node variables, unless 
    
	$myhostname = $::hostname
	$myip = $::ipaddress
    $mylocaldomain = $::domain

	# Add puppet server, gateway, smtp ip to default hosts file
	# but do not duplicate entries on these hosts. Assumes that,
	# puppetmaster, smtp and the gateway host are on different systems.
	
    # puppet server may live in same domain as the actual host
    if $puppetserver_domain == '' {
        $mypuppetserver_domain = $::domain
    } else {
	    $mypuppetserver_domain = $puppetserver_domain
	}
	
    # gateway may live in same domain as the actual host
    if $gateway_domain == '' {
        $mygateway_domain = $::domain
    } else {
       $mygateway_domain = $mygateway_domain
	}
	
    # smtp server may live in same domain as the actual host
    if $smtp_domain == '' {
        $mysmtp_domain = $::domain
    } else {
	    $mysmtp_domain = $smtp_domain
	}
	
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
