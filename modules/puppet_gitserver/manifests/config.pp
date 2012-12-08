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
	
	## create the git depot for the developers
	## in group '$gitgrp' if not existing.
	
	exec { "Create_Depot_Group_${name}":
	   command => "/bin/mkdir /srv/${gitgrp}",
	    onlyif => "/usr/bin/test ! -d /srv/${gitgrp}",
	}
	
	exec { "Chown_${name}":
	    command => "/bin/chown root:${gitgrp} /srv/${gitgrp}",
	      subscribe => Exec["Create_Depot_Group_${name}"],
	    refreshonly => true,
	}
	
	exec { "Chmod_${name}":
	    command => "/bin/chmod 0750 /srv/${gitgrp}",
	      subscribe => Exec["Create_Depot_Group_${name}"],
	    refreshonly => true,
	}
	
	## create the project directory if not already existing.
	
	exec { "Create_Directory_${name}":
	        command => "/bin/mkdir /srv/${gitgrp}/${projectname}",
	    onlyif => "/usr/bin/test ! -d /srv/${gitgrp}/${projectname}",
	}
	
	exec { "Initilize_Depot_${name}":
	         cwd => "/srv/${gitgrp}/${projectname}",
	        command => "/usr/bin/git init --bare",
	      subscribe => Exec["Create_Directory_${name}"],
	    refreshonly => true,
	}
	
	## finally set the ownerships to the new project to the git group
	
	exec { "Recursive_Chown_${name}":
	    command => "/bin/chown -R ${gitgrp}:${gitgrp} /srv/${gitgrp}/${projectname}",
	      subscribe => Exec["Initilize_Depot_${name}"],
	    refreshonly => true,
	}
	
}