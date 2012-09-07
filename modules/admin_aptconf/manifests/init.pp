##
## This class configures APT
##
class admin_aptconf {

	# only the 'sources.list' file is included 
	# when cron runs our script 'upgrade.security'

	file { "/etc/apt/sources.list":
		source => "puppet:///modules/admin_aptconf/sources.list",
		 owner => "root",
		 group => "root",
		  mode => '0644',
	}

	# put all other sources in the sources.list.d directory. The source list	
	# snippets is disabled during cron unattended upgrade security runs.
	
	
	
	### repo file snippets

	file { "/etc/apt/sources.list.d/main.list":
		source => "puppet:///modules/admin_aptconf/main.list",
		 owner => "root",
		 group => "root",
		  mode => '0644',
	}


	file { "/etc/apt/sources.list.d/updates.list":
		source => "puppet:///modules/admin_aptconf/updates.list",
		 owner => "root",
		 group => "root",
		  mode => '0644',
	}

    ### end repo file snippets



	## Configures APT for recommend/suggests to "false"
	## and to be more verbose when using aptitude.
	
	file { "/etc/apt/apt.conf":
		source => "puppet:///modules/admin_aptconf/apt.conf",
		 owner => 'root',
		 group => 'root',
		  mode => '0644',

	}	

	## Configures daily updates/downloads but do NOT auto upgrade (i.e. do not
	## use the debian package unattended-upgrades. Use my 'upgrade.security'
	
	file { "/etc/apt/apt.conf.d/02periodic":
		source => "puppet:///modules/admin_aptconf/02periodic",
		 owner => 'root',
		 group => 'root',
		  mode => '0644',
	}
	
	# create a bin subdirectory directory only for an unattended cron upgrade
	# script. This is required to shuffle source lists when run unattended.
	
	file { "/etc/apt/.sources.list.d":
		ensure => "directory",
		owner => 'root',
		group => 'root',
	}
	
	
	## Always use aptitude safe-upgrade, and call tripwire if it exists

		file { "/root/bin/upgrade":
			source => "puppet:///modules/admin_aptconf/aptitude.twupgrade.sh",
			 owner => 'root',
			 group => 'root',
			  mode => '0700',
		}
		
	## Always use this script for unattended security updates. This script
	## will only read 'sources.list' and not any snippets in /sources.list.d

		file { "/root/bin/upgrade.security":
			source => "puppet:///modules/admin_aptconf/aptitude.unattended_upgrade.sh",
			 owner => 'root',
			 group => 'root',
			  mode => '0700',
		}	

}
