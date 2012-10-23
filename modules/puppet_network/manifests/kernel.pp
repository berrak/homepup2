##
## Setting up kernel networking with
## /etc/sysctl.conf
##
class puppet_network::kernel {

    include puppet_network::params
    
    # facter

    $myhost = $::hostname


    # enable kernel 'ipv4 forward' for all forwarding (gateway) hosts
    
    if $myhost in puppet_network::params:forwardinghostslist {

        $ipv4_forwarding = 'net.ipv4.ip_forward = 1'
        
    } else {
    
        $ipv4_forwarding = 'net.ipv4.ip_forward = 0'

    }
    
    file { "/etc/sysctl.conf":
        content =>  template( 'puppet_network/sysctl.conf.erb' ),
          owner => 'root',
          group => 'root',
           mode => '0644',
		 notify => Exec["UPDATING_KERNEL_SYSCTL_CONFIGURATION"],
    }   
 
	exec { "UPDATING_KERNEL_SYSCTL_CONFIGURATION" :
		    command => "/sbin/sysctl -p",
		refreshonly => true,
	}   
    

}