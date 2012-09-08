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
		
	file { "/root/bin/tripwire.recovertextfiles" :
		 source => "puppet:///modules/puppet_tripwire/tripwire.recovertextfiles",
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

	file { "/root/bin/tripwire.init" :
		 source => "puppet:///modules/puppet_tripwire/tripwire.init",
		  owner => 'root',
		  group => 'root',
		   mode => '0700',
		require => File["/root/bin"],
	}


    # template

    $mydomain = $::domain

	file { "/root/bin/tripwire.emailtest" :
            content =>  template( 'puppet_tripwire/tripwire.emailtest.erb' ),
		  owner => 'root',
		  group => 'root',
		   mode => '0700',
		require => File["/root/bin"],
	}
	
	# Create a mount directory only for tripwire (use system default mode setting).
	file { "/media/tripwire":
	    ensure => "directory",
	     owner => 'root',
	     group => 'root',
    }

}
