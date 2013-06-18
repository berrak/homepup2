##
## Class to manage a set of iptables firewall scripts 
##
class puppet_iptables inherits root_home {

    include le_iptables::install, le_iptables::config

}