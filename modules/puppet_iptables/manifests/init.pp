##
## Class to manage a set of iptables firewall scripts 
##
class puppet_iptables inherits admin_home {

    include puppet_iptables::install, puppet_iptables::config, puppet_iptables::params

}