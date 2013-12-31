#
# Defines backup job by cron for project
#
# Assumes that the project is placed directly below
# user home directory ~/$projectname
#
#
# Sample usage:
#
#     puppet_komodo_devsetup::backup { 'jensen' :
#     		projectname => 'openjensen',
#     } 
#
define puppet_komodo_devsetup::backup ( $projectname='') {

	if $projectname =='' {
		fail("FAIL: Missing required project name!")
	}
			
	file { "/etc/cron.daily/${projectname}":
		content =>  template("puppet_komodo_devsetup/dailycron.${projectname}.erb"),
		owner => 'root',
		group => 'root',
		 mode => '0755',
		require => Class["puppet_komodo_devsetup::project"],
	}
		
}