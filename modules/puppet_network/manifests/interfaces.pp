##
## Class handling the networking file content i.e. (/etc/network/interfaces).
## Defaults to set up the loopback interface, add one interface on eth0, and 
## enable the firewall with templates and facter. Default gateway must be given.
## 
## If interfaces > 1 then a 'interfaces' file must pre-exist for that given host.
##
## Sample Usage:
##
##  class { puppet_network::interfaces : broadcastnet => '192.168.0.0', defaultgateway => '192.168.0.1' }
##  class { puppet_network::interfaces : interfaces => '2', hostnm => 'gondor',
##                                                     addfirewall => 'false' }
##
##
class puppet_network::interfaces ( $interfaces = '1',
                                   $addfirewall = 'true',
                                   $broadcastnet = '',
                                   $defaultgateway = '',
                                   $hostnm = '',
) {
    
    include puppet_network::kernel, puppet_network::service, puppet_network::params
    
    
    # Don't use network-manager - home use only wired and static IP's (configured "manually" with puppet)
    package { "network-manager-gnome":
        ensure => purged,
    }
    
    package { "network-manager":
        ensure => purged,
        require => Package["network-manager-gnome"],
    }
    
    
    
    if ! ( $addfirewall in [ 'true', 'false' ]) {
        fail("FAIL: Firewall parameter ($addfirewall) must be 'true' or 'false'.")
    }
    
    if ! ( $interfaces in [ '1', '2' ]) {
        fail("FAIL: Sorry, network interfaces parameter ($interfaces) must be '1' or '2'.")
    }
    
    if  ( $interfaces == '1' ) and ( $defaultgateway == '' ) {
    
        fail("FAIL: Sorry, default gateway parameter can't be empty for single interfaces.")
    }
    
    if  ( $interfaces == '1' ) and ( $broadcastnet == '' ) {
    
        fail("FAIL: Sorry, broadcast net parameter can't be empty for single interfaces.")
    }
     
    # to reach the sub domain 'sec.home.tld' we need to add a static route frome 'home.tld'
    
    if $broadcastnet == $::puppet_network::params::mysubdomain_net {
    
        $addroute_eth0 = ''
        $removeroute_eth0 = ''
        
    } else {
                                   
		# NOTE: Skip to use bridge for host 'dell'
        #if $hostnm == 'dell' {
        #    $addroute_kvmbr0 = $::puppet_network::params::addroute_kvmbr0
        #    $removeroute_kvmbr0 = $::puppet_network::params::removeroute_kvmbr0         
        #} else {
		
        $addroute_eth0 = $::puppet_network::params::addroute_eth0
        $removeroute_eth0 = $::puppet_network::params::removeroute_eth0
		
        #}  
    }
                        
    if ( $interfaces == '1' ) {
        
        ## configure as eth0
        
        $auto0_stanza = 'auto eth0'
        $allow_hotplug0 = 'allow-hotplug eth0'
        
        # NOTE: Skip 'dell' as our experimental virtual host
        # facter just deliver data empty as it seee fit!
        #if $hostnm == 'dell' {
        #    $iface0 = 'iface kvmbr0 inet static'
        #    $eth0_ip = "address $::ipaddress"
        #    $eth0_netmask = 'netmask 255.255.255.0'
        #    $eth0_network = 'network 192.168.0.0'           
        #} else {
		
		$iface0 = 'iface eth0 inet static'
		$eth0_ip = "address $::ipaddress_eth0"
		$eth0_netmask = "netmask $::netmask_eth0"
		$eth0_network = "network $::network_eth0"
			
        #}
        
        $bcstnet0 = "broadcast $broadcastnet"
        $gateway0 = "gateway $defaultgateway"

        # Build up our interface file
    
        if $addfirewall == 'true' {
            $loadfirewall = $::puppet_network::params::myloadfirewall
        } elsif $addfirewall == 'false' {
            $loadfirewall = ''
        } else {
            fail("FAIL: Unrecognized option loading firewall!")
        }

        if $hostnm == 'dell' {
            file { "/etc/network/interfaces" :
                ensure => present,
                content => template("puppet_network/interfaces.${hostnm}.erb"),
                owner => 'root',
                group => 'root',
                notify => Exec["network_restart"],
            } 
        } else {
            file { "/etc/network/interfaces" :
                ensure => present,
               content => template("puppet_network/interfaces.erb"),
                 owner => 'root',
                 group => 'root',
                notify => Exec["network_restart"],
            }
        }

    }
    elsif ( $interfaces == '2'  ) and ( $hostnm != '' ) {
        
        
        # Build up our interface file
    
        if $addfirewall == 'true' {
            $loadfirewall = $::puppet_network::params::myloadfirewall
        } elsif $addfirewall == 'false' {
            $loadfirewall = ''
        } else {
            fail("FAIL: Unrecognized option loading firewall!")
        }     
        
        file { "/etc/network/interfaces" :
            ensure => present,
           content => template("puppet_network/interfaces.${hostnm}.erb"),
             owner => 'root',
             group => 'root',
            notify => Exec["network_restart"],
        }
        
        # sometimes the gateway have built in unused NICs. Then we need to
        # use some udev rules to 'lock' the logical name of the interface.
        
        if $::hostname == $::puppet_network::params::securegatewayhost {
        
            file { "/etc/udev/rules.d/70-persistent-net.rules" :
                ensure => present,
                source => "puppet:///modules/puppet_network/70-persistent-net.rules.${hostnm}",
                 owner => 'root',
                 group => 'root',
                notify => Exec["network_restart"],
            }       
        
        }
    
    }

    else {
    
        fail("FAIL: No hostname parameter ($hostnm) given!")
    
    }

}