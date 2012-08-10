##
## This class configures APT
##
class admin_apt {

	file { "/etc/apt/sources.list":
		source => "puppet:///modules/admin_apt/sources.list",
		 owner => "root",
		 group => "root",
		  mode => '0644',
	}

	## Configures APT for recommend/suggests to "false"
	## and to be more verbose when using aptitude.
	
	file { "/etc/apt/apt.conf":
		source => "puppet:///modules/admin_apt/apt.conf",
		 owner => 'root',
		 group => 'root',
		  mode => '0644',

	}	

	## Configures daily updates/downloads but NOT auto upgrade
	
	file { "/etc/apt/apt.conf.d/02periodic":
		source => "puppet:///modules/admin_apt/02periodic",
		 owner => 'root',
		 group => 'root',
		  mode => '0644',

	}
	
	## Always use aptitude safe-upgrade, and call tripwire if it exists

		file { "/root/bin/upgrade":
			source => "puppet:///modules/admin_apt/aptitude.twupgrade",
			 owner => 'root',
			 group => 'root',
			  mode => '0700',
		}

}
