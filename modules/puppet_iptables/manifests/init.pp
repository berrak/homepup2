##
## Class to manage a set of iptables firewall scripts 
##
class puppet_iptables {

    include puppet_iptables::install, puppet_iptables::service, puppet_iptables::config, puppet_iptables::params

}