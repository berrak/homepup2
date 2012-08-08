##
## This class manage the wrappers that the only
## the root user can run for manual agent cli runs.
##
class puppet_agent::tools {

	file { "/root/bin/puppet.exec":
		source => "puppet:///modules/puppet_agent/puppet.exec",
		owner => "root",
		group => "root",
		mode => 0700,
		require => File["/root/bin"],
	}
	
	file { "/root/bin/puppet.simulate":
		source => "puppet:///modules/puppet_agent/puppet.simulate",
		owner => "root",
		group => "root",
		mode => 0700,
		require => File["/root/bin"],
	}
			
}
