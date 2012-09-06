##
## This class configures APT
##
class admin_aptconf {

	# this source list is always executed, eventually unattended	

	file { "/etc/apt/sources.list":
		source => "puppet:///modules/admin_aptconf/sources.list",
		 owner => "root",
		 group => "root",
		  mode => '0644',
	}

	# put all other sources in the sources.list.d directory.	
	# source list snippets may be disabled during security runs. 	

	file { "/etc/apt/sources.list.d/main.list":
		source => "puppet:///modules/admin_aptconf/main.list",
		 owner => "root",
		 group => "root",
		  mode => '0644',
	}


	## Configures APT for recommend/suggests to "false"
	## and to be more verbose when using aptitude.
	
	file { "/etc/apt/apt.conf":
		source => "puppet:///modules/admin_aptconf/apt.conf",
		 owner => 'root',
		 group => 'root',
		  mode => '0644',

	}	

	## Configures daily updates/downloads but NOT auto upgrade
	
	file { "/etc/apt/apt.conf.d/02periodic":
		source => "puppet:///modules/admin_aptconf/02periodic",
		 owner => 'root',
		 group => 'root',
		  mode => '0644',

	}
	
	## Always use aptitude safe-upgrade, and call tripwire if it exists

		file { "/root/bin/upgrade":
			source => "puppet:///modules/admin_aptconf/aptitude.twupgrade",
			 owner => 'root',
			 group => 'root',
			  mode => '0700',
		}

}
