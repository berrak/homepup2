##
## Setting up kernel networking with
## /etc/sysctl.conf
##
class puppet_network::kernel {

    # facter

    $myhost = $::hostname


    # special case for our gateway host (enable forwarding)
    
    if $myhost == 'gondor' {

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