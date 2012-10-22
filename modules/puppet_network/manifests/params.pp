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
    
}