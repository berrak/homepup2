##
## This class re-starts the networking service.
## Use ipup/ipdown to ensure configuration re-read 
## all (auto) intefaces are indeed brought up!
##
class puppet_network::service {

  exec { "network_restart":
          command => "ifdown --force --all && ifup --force --all",
             path => "/sbin",
      refreshonly => true,

	}

}
