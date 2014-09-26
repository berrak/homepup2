##
## This class manage iptables
##
class puppet_iptables::install {

    package  { 'iptables' :
                ensure => installed }
}
