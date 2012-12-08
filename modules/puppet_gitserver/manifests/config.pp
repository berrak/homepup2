##
## Manage the git depot on the server
##
## Sample use:
##
##  puppet_gitserver::config { 'git2_project1': gitgrp => 'git2',projectname => 'project1'}
##
define puppet_gitserver::config ( $gitgrp ='', $projectname = '' ) {

    include puppet_gitserver::install
	
	# maybe not required...
    # include puppet_gitsrv::params
    
    if $projectname == '' {

        fail("FAIL: No project name ($projectname) given as parameter.")
    }

    if $gitgrp == '' {

        fail("FAIL: No git group name ($gitgrp) given as parameter.")
    }
	
	# create the git depot for the developers
	# in group '$gitgrp' if it does not exist
	
	exec { "Create_depot_${name}":
	   command => "/bin/mkdir /srv/${gitgrp}",
	    onlyif => "test ! -d /srv/${gitgrp}",
	}
	
	exec { "Chown_${name}":
	    command => "/bin/chown root:${gitgrp} /srv/${gitgrp}",
	      subscribe => Exec["Create_depot_${name}"],
	    refreshonly => true,
	}
	
	exec { "Chmod_${name}":
	    command => "/bin/chmod 0750 /srv/${gitgrp}",
	      subscribe => Exec["Create_depot_${name}"],
	    refreshonly => true,
	}	
    
}