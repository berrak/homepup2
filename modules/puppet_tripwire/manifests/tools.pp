##
## This class manage help binaries
##
class puppet_tripwire::tools {

	file { "/root/bin/tripwire.check" :
		 source => "puppet:///modules/puppet_tripwire/tripwire.check",
    	  owner => 'root',
		  group => 'root',
		   mode => '0700',
		require => File["/root/bin"],
	}
		
	file { "/root/bin/tripwire.createtextfiles" :
		 source => "puppet:///modules/puppet_tripwire/tripwire.createtextfiles",
		  owner => 'root',
		  group => 'root',
		   mode => '0700',
		require => File["/root/bin"],
	}

	file { "/root/bin/tripwire.report" :
		 source => "puppet:///modules/puppet_tripwire/tripwire.report",
		  owner => 'root',
		  group => 'root',
		   mode => '0700',
		require => File["/root/bin"],
	}


	file { "/root/bin/tripwire.updateconfiguration" :
		 source => "puppet:///modules/puppet_tripwire/tripwire.updateconfiguration",
		  owner => 'root',
		  group => 'root',
		   mode => '0700',
        require => File["/root/bin"],
	}


	file { "/root/bin/tripwire.updatepolicy" :
		 source => "puppet:///modules/puppet_tripwire/tripwire.updatepolicy",
		  owner => 'root',
		  group => 'root',
		   mode => '0700',
		require => File["/root/bin"],
	}


	# Create a mount directory only for tripwire.
	file { "/media/tripwire":
	    ensure => "directory",
	     owner => 'root',
	     group => 'root',
		  mode => '0550',
    }

}