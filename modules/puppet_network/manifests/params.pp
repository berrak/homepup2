##
## parameters for network configuartion
##
class puppet_network::params {

    $myfwrestore = '/root/bin/IPTABLES.FW'
    
    $myloadfirewall = "pre-up /sbin/iptables-restore < $myfwrestore"

}