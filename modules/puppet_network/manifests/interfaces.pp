##
## Class handling the networking file content
## i.e. (/etc/network/interfaces). Defaults to
## setting up the loopback interface and enable
## the firewall loading. Handles one/two interfaces.
##
## Sample Usage:
##
##  class { puppet_network::interfaces :
##      iface0 => 'eth0', gateway0 => '192.168.0.1',
##      bcstnet0 => '192.168.0.255',
##      iface1 => 'eth1', gateway1 => '192.168.1.1',
##      bcstnet1 => '192.168.1.255',
##      addfirewall => 'true' }
##
##
class puppet_network::interfaces ( $iface_zero = '',
                                   $gateway_zero = '',
                                   $bcstnet_zero = '',
                                   $iface_one = '',
                                   $gateway_one = '',
                                   $bcstnet_one = '',
                                   $addfirewall = 'true',
) {
    
    if ! ( $addfirewall in [ "true", "false" ]) {
        fail("Firewall parameter ($addfirewall) must be 'true' or 'false'")
    }
    
                        
    if ( $iface_zero != '' ) and ( $iface_one != '' ) {
        notify {"Setting up interfaces for eth0 ($::ipaddress_eth0) and eth1 ($::ipaddress_eth1) with static addresses.":}
        
        ## eth0
        
        $allow_hotplug0 = "allow-hotplug $iface_zero"
        $iface0 = "iface $iface_zero inet static"
        
        # facter variables
        
        $eth0_ip = "address $::ipaddress_eth0"
        $eth0_netmask = "netmask $::netmask_eth0"
        $eth0_network = "network $::network_eth0"
        
        $bcstnet0 = "broadcast $bcstnet_zero"
        $gateway0 = "gateway $gateway_zero"
        
        ## eth1
        
        $allow_hotplug1 = "allow-hotplug $iface_one"
        $iface1 = "iface $iface_one inet static"
        
        # facter variables
        
        $eth1_ip = "address $::ipaddress_eth1"
        $eth1_netmask = "netmask $::netmask_eth1"
        $eth1_network = "network $::network_eth1"
        
        $bcstnet1 = "broadcast $bcstnet_one"
        $gateway1 = "gateway $gateway_one"
        
        
    }
    elsif ( $iface_zero != '' ) and ( $iface_one == '' ) {
        notify{"Setting up eth0 with static address ($::ipaddress_eth0).":}
        
        ## eth0
        
        $allow_hotplug0 = "allow-hotplug $iface_zero"
        $iface0 = "iface $iface_zero inet static"
        
        # facter variables
        
        $eth0_ip = "address $::ipaddress_eth0"
        $eth0_netmask = "netmask $::netmask_eth0"
        $eth0_network = "network $::network_eth0"
        
        $bcstnet0 = "broadcast $bcstnet_zero"
        $gateway0 = "gateway $gateway_zero"
        
    
    }
    elsif ( $iface_zero == '') and ( $iface_one != '' ) {
        notify{"Setting up eth1 with static ($::ipaddress_eth1) address.":}
        
        ## eth1
        
        $allow_hotplug1 = "allow-hotplug $iface_one"
        $iface1 = "iface $iface_one inet static"
        
        # facter variables
        
        $eth1_ip = "address $::ipaddress_eth1"
        $eth1_netmask = "netmask $::netmask_eth1"
        $eth1_network = "network $::network_eth1"
        
        $bcstnet1 = "broadcast $bcstnet_one"
        $gateway1 = "gateway $gateway_one"
        
    
    }
    else {
        notify{"none set":}
        fail("No network interfaces set!")
    
    }

    # Build up our interface file
    
    if $addfirewall == 'true' {
        $loadfirewall = 'pre-up /sbin/iptables-restore < /root/bin/IPTABLES.FW'
    } elsif $addfirewall == 'false' {
        $loadfirewall = ''
    } else {
        fail("Unrecognized option loading firewall!")
    }
    
    ## Todo: add restart of networking when this file changes 
    
    file { "/etc/network/interfaces" :
         ensure => present,
        content => template("puppet_network/interfaces.erb"),
          owner => 'root',
          group => 'root',
    }



}