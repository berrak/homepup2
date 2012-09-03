##
## Class handling the networking file content
## i.e. (/etc/network/interfaces). Defaults to
## setting up the loopback interface and enable
## the firewall loading. Handles one/two interfaces.
##
## Sample Usage:
##
##  class { puppet_network::interfaces :
##      iface_zero => 'eth0', gateway_zero => '192.168.0.1',
##      bcstnet_zero => '192.168.0.255',
##      iface_one => 'eth1', gateway_one => '192.168.1.1',
##      bcstnet_one => '192.168.1.255',
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
    
    include puppet_network::service
    
    if ! ( $addfirewall in [ "true", "false" ]) {
        fail("Firewall parameter ($addfirewall) must be 'true' or 'false'")
    }
    
                        
    if ( $iface_zero != '' ) and ( $iface_one != '' ) {
        
        ## eth0
        
        $auto0_stanza = "auto $iface_zero"
        $allow_hotplug0 = "allow-hotplug $iface_zero"
        $iface0 = "iface $iface_zero inet static"
        
        # facter variables
        
        $eth0_ip = "address $::ipaddress_eth0"
        $eth0_netmask = "netmask $::netmask_eth0"
        $eth0_network = "network $::network_eth0"
        
        $bcstnet0 = "broadcast $bcstnet_zero"
        
        if $gateway_zero != '' {
            $gateway0 = "gateway $gateway_zero"
        } else {
            $gateway0 =''
        }
        
        ## eth1
        
        $secondaryinterfacetext = '# The secondary network interface'
        
        $auto1_stanza = "auto $iface_one"
        $allow_hotplug1 = "allow-hotplug $iface_one"
        $iface1 = "iface $iface_one inet static"
        
        # facter variables
        
        $eth1_ip = "address $::ipaddress_eth1"
        $eth1_netmask = "netmask $::netmask_eth1"
        $eth1_network = "network $::network_eth1"
        
        $bcstnet1 = "broadcast $bcstnet_one"
        
        if $gateway_one != '' {
            $gateway1 = "gateway $gateway_one"
        } else {
            $gateway1 = ''
        }
        
        
    }
    elsif ( $iface_zero != '' ) and ( $iface_one == '' ) {
        
        ## eth0
        
        $auto0_stanza = "auto $iface_zero"
        $allow_hotplug0 = "allow-hotplug $iface_zero"
        $iface0 = "iface $iface_zero inet static"
        
        # facter variables
        
        $eth0_ip = "address $::ipaddress_eth0"
        $eth0_netmask = "netmask $::netmask_eth0"
        $eth0_network = "network $::network_eth0"
        
        $bcstnet0 = "broadcast $bcstnet_zero"
        
        if $gateway_zero != '' {
            $gateway0 = "gateway $gateway_zero"
        } else {
            $gateway0 =''
        }
        
        ## Set unused eth1 template variables to empty strings
        
        $secondaryinterfacetext = ''
        
        $auto1_stanza = ''
        $allow_hotplug1 = ''
        $iface1 = ''
        $eth1_ip = ''
        $eth1_netmask = ''
        $eth1_network = ''
        $bcstnet1 = ''
        $gateway1 = ''
    
    }
    elsif ( $iface_zero == '') and ( $iface_one != '' ) {
        
        ## eth1
        
        $auto1_stanza = "auto $iface_one"
        $allow_hotplug1 = "allow-hotplug $iface_one"
        $iface1 = "iface $iface_one inet static"
        
        # facter variables
        
        $eth1_ip = "address $::ipaddress_eth1"
        $eth1_netmask = "netmask $::netmask_eth1"
        $eth1_network = "network $::network_eth1"
        
        $bcstnet1 = "broadcast $bcstnet_one"
        
        if $gateway_one != '' {
            $gateway1 = "gateway $gateway_one"
        } else {
            $gateway1 = ''
        }
        
        
        ## Set unused eth0 template variables to empty strings
        
        $secondaryinterfacetext = ''
        
        $auto0_stanza = ''
        $allow_hotplug0 = ''
        $iface0 = ''
        $eth0_ip = ''
        $eth0_netmask = ''
        $eth0_network = ''
        $bcstnet0 = ''
        $gateway0 = ''        
 
    }
    else {
    
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
    
    file { "/etc/network/interfaces" :
         ensure => present,
        content => template("puppet_network/interfaces.erb"),
          owner => 'root',
          group => 'root',
         notify => Exec["network_restart"],
    }



}