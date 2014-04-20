##
## This class configures APT
##
class admin_aptconf {

    include admin_aptconf::params

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
	
	file { "/etc/apt/sources.list.d/contrib.list":
		source => "puppet:///modules/admin_aptconf/contrib.list",
		 owner => "root",
		 group => "root",
		  mode => '0644',
	}	
	
	
	
	
	# A specific host which require 'non-free' for networking firmware
	
	if $::hostname == $::admin_aptconf::params::mynonfreehost {
	
		file { "/etc/apt/sources.list.d/nonfree.list":
			source => "puppet:///modules/admin_aptconf/nonfree.list",
			 owner => "root",
			 group => "root",
			  mode => '0644',
		}
	
	}
	
	if $::hostname == $::admin_aptconf::params::wifibcm80211 {
	
		file { "/etc/apt/sources.list.d/backport.list":
			source => "puppet:///modules/admin_aptconf/backport.list",
			 owner => "root",
			 group => "root",
			  mode => '0644',
		}
		
		
	
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
	
	## Some hosts (standard for servers) have /tmp partition mounted 'noexec'
	## Apt may need 'exec' /tmp during install. This remount /tmp for apt. 
	
	if $::hostname in $::admin_aptconf::params::hosttmpremountexeclist {
	
		file { "/etc/apt/apt.conf.d/50tmpremountexec":
		    source => "puppet:///modules/admin_aptconf/50tmpremountexec",
             owner => 'root',
		     group => 'root',
		      mode => '0644',
	    }
	
	}
	
	
	# create a bin subdirectory directory only for an unattended cron upgrade
	# script. This is required to shuffle source lists when run unattended.
	
	file { "/etc/apt/.sources.list.d":
		ensure => "directory",
		owner => 'root',
		group => 'root',
	}
	
	
	## This scrip use aptitude safe-upgrade, and call tripwire if it exists

		file { "/root/bin/upgrade":
			source => "puppet:///modules/admin_aptconf/upgrade.sh",
			 owner => 'root',
			 group => 'root',
			  mode => '0700',
		}
		
	## Always use this script for unattended security updates. This script
	## will only read 'sources.list' and not any snippets in /sources.list.d

		file { "/root/jobs/cron.upgradesecurity":
			source => "puppet:///modules/admin_aptconf/cron.upgradesecurity",
			 owner => 'root',
			 group => 'root',
			  mode => '0700',
		}	

    ## Set up a cron job for this, 4 times per month.
	
		file { "/etc/cron.d/upgradesecurity":
			source => "puppet:///modules/admin_aptconf/upgradesecurity",
			 owner => 'root',
			 group => 'root',
			  mode => '0644',
		}	
	
}
