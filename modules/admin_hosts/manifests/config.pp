##
## This class manage the setting in each node host file.
## 
##
class admin_hosts::config (
          $puppetserver_ip = '',     $puppetserver_hostname = '',     $puppetserver_domain = '',
               $gateway_ip = '',          $gateway_hostname = '',          $gateway_domain = '',
        $gateway_subdomain ='',
                  $smtp_ip = '',             $smtp_hostname = '',             $smtp_domain = '',
      $gateway_security_ip = '', $gateway_security_hostname = '', $gateway_security_domain = '',						
) {

	
    include admin_hosts::params
	$apache_virtual_host = $::admin_hosts::params::apache_virtual_host
	
	# Facter node variables
    
	$myhostname = $::hostname
	
	# don't use a specific interface - without explicit, main interaface is eth0 or an enslaved bridge
	$ip_eth0 = $::ipaddress
	
    $ip_eth1 = $::ipaddress_eth1
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
        $mygateway_domain = $gateway_domain
	}
	
    # smtp server may live in same domain as the actual host
    if $smtp_domain == '' {
        $mysmtp_domain = $::domain
    } else {
	    $mysmtp_domain = $smtp_domain
	}
		
	case $myhostname {
    
        'carbon' : {
		
            file { '/etc/hosts' :
                content =>  template( 'admin_hosts/puppetserver.hosts.erb' ),
                  owner => 'root',
                  group => 'root',
                   mode => '0644',
            }
        
        }
	
        'gondor' : {
        
            file { '/etc/hosts' :
                content =>  template( 'admin_hosts/gateway.hosts.erb' ),
                  owner => 'root',
                  group => 'root',
                   mode => '0644',
            }

        }
		
        'asgard' : {
        
            file { '/etc/hosts' :
                content =>  template( 'admin_hosts/security.hosts.erb' ),
                  owner => 'root',
                  group => 'root',
                   mode => '0644',
            }

        }		
		
		
        'rohan' : {
        
            file { '/etc/hosts' :
                content =>  template( 'admin_hosts/smtp.hosts.erb' ),
                  owner => 'root',
                  group => 'root',
                   mode => '0644',
            }

        }	
		
        'warp' : {
        
            file { '/etc/hosts' :
                content =>  template( 'admin_hosts/fileserver.hosts.erb' ),
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
