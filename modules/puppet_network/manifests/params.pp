##
## parameters for network configuartion
##
class puppet_network::params {

    $myfwrestore = '/root/bin/IPTABLES.FW'
    
    $myloadfirewall = "pre-up /sbin/iptables-restore < $myfwrestore"
    
    # Some hosts have > 2  ICs. Then the system must ensure that
    # each interfaces' logical name (i.e. eth0, eth1, ..) is not
    # changed by the kernel (firewall, forwarding, interface issues).
    # asgard is the internal (internal server security) gateway
    
    $securegatewayhost = 'asgard'
    
    # add static route stanzas to reach sub domain (assumes eth0)
    
    $mysecuregateway_ip = '192.168.0.254'
    $mysubdomain_net = '192.168.2.0'
    
    $addroute_eth0 = "post-up /sbin/route add -net $mysubdomain_net netmask 255.255.255.0 gw $mysecuregateway_ip dev eth0"
    $removeroute_eth0 = "pre-down /sbin/route del -net $mysubdomain_net netmask 255.255.255.0 gw $mysecuregateway_ip dev eth0"

    # NOT used: Virtual host (dell) enslaves eth0 to kvmbr0
    $addroute_kvmbr0 = "post-up /sbin/route add -net $mysubdomain_net netmask 255.255.255.0 gw $mysecuregateway_ip dev kvmbr0"
    $removeroute_kvmbr0 = "pre-down /sbin/route del -net $mysubdomain_net netmask 255.255.255.0 gw $mysecuregateway_ip dev kvmbr0"
    
}