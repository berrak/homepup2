##
## This class manage iptables
##
class puppet_iptables::service {

	
	# reload firewall configuration on changes
	
	exec { "/bin/sh /root/bin/fw.desktop":
		subscribe => File["/root/bin/fw.desktop"],
		refreshonly => true,
	}

	exec { "/bin/sh /root/bin/fw.gateway":
		subscribe => File["/root/bin/fw.gateway"],
		refreshonly => true,
	}

}
