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
class puppet_network::interfaces ( $iface0 = '',
                                   $gateway0 = '',
                                   $bcstnet0 = '',
                                   $iface1 = '',
                                   $gateway1 = '',
                                   $bcstnet1 = '',
                                   $addfirewall = 'true',
) {
    
    if ! ( $addfirewall in [ "true", "false" ]) {
        fail("Firewall parameter ($addfirewall) must be 'true' or 'false'")
    }
    
                        
    if ( $iface0 != '' ) and ( $iface1 != '' ) {
        notify {"eth0 and eth1 set":}
        
        ## eth0
        
        $allow_hotplug0 = "allow-hotplug $iface0"
        $iface0 = "iface $iface0 inet static"
        
        # facter variables
        
        $eth0_ip = "address $::ipaddress_eth0"
        $eth0_netmask = "netmask $::netmask_eth0"
        $eth0_network = "network $::network_eth0"
        
        $bcstnet0 = "broadcast $bcstnet0"
        $gateway0 = "gateway $gateway0"
        
        ## eth1
        
        $allow_hotplug1 = "allow-hotplug $iface1"
        $iface1 = "iface $iface1 inet static"
        
        # facter variables
        
        $eth1_ip = "address $::ipaddress_eth1"
        $eth1_netmask = "netmask $::netmask_eth1"
        $eth1_network = "network $::network_eth1"
        
        $bcstnet1 = "broadcast $bcstnet1"
        $gateway1 = "gateway $gateway1"
        
        
    }
    elsif ( $iface0 != '' ) and ( $iface1 == '' ) {
        notify{"eth0 set":}
        
        ## eth0
        
        $allow_hotplug0 = "allow-hotplug $iface0"
        $iface0 = "iface $iface0 inet static"
        
        # facter variables
        
        $eth0_ip = "address $::ipaddress_eth0"
        $eth0_netmask = "netmask $::netmask_eth0"
        $eth0_network = "network $::network_eth0"
        
        $bcstnet0 = "broadcast $bcstnet0"
        $gateway0 = "gateway $gateway0"
        
    
    }
    elsif ( $iface0 == '') and ( $iface1 != '' ) {
        notify{"eth1 set":}
        
        ## eth1
        
        $allow_hotplug1 = "allow-hotplug $iface1"
        $iface1 = "iface $iface1 inet static"
        
        # facter variables
        
        $eth1_ip = "address $::ipaddress_eth1"
        $eth1_netmask = "netmask $::netmask_eth1"
        $eth1_network = "network $::network_eth1"
        
        $bcstnet1 = "broadcast $bcstnet1"
        $gateway1 = "gateway $gateway1"
        
    
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