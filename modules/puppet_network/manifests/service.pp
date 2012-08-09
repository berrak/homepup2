##
## This class re-starts the networking service.
##
class puppet_network::service {

  exec { "network_restart":
          command => ["/etc/init.d/networking stop", "/etc/init.d/networking start"],
             path => "/bin:/usr/bin:/sbin:/usr/sbin",
      refreshonly => true,
		  require => File["/etc/network/interfaces"],

	}

}
