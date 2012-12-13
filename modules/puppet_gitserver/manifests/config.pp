##
## Manage the git depot on the server
##
## Sample use:
##
##  puppet_gitserver::config { 'git2_project1': gitgrp => 'git2',projectname => 'project1'}
##
define puppet_gitserver::config ( $gitgrp ='', $projectname = '' ) {

    include puppet_gitserver::install
    
    if $projectname == '' {

        fail("FAIL: No project name ($projectname) given as parameter.")
    }

    if $gitgrp == '' {

        fail("FAIL: No git group name ($gitgrp) given as parameter.")
    }
	
	# ensure that the git-user have been created by admin already
	# i.e. '#adduser --shell /usr/bin/git-shell $gitgrp')
	
	exec { "${name}_FAIL_MISSING_GIT_USER_($gitgrp)_ADMIN_USE_ADDUSER_TO_ADD-Aborting_Puppet_Run":
	   command => "/usr/bin/pkill -TERM puppet",
	    onlyif => "/usr/bin/test ! -d /home/${gitgrp}",
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
	
	file { "/srv/${gitgrp}/${projectname}.git":
		 ensure => "directory",
		  owner => $gitgrp,
		  group => $gitgrp,
		   mode => '0750',
		require => Exec["Create_Depot_Group_${name}"],
	}
	
	exec { "Initilize_Depot_${name}":
	         cwd => "/srv/${gitgrp}/${projectname}.git",
	        command => "/usr/bin/git init --bare",
	      subscribe => File["/srv/${gitgrp}/${projectname}.git"],
	    refreshonly => true,
	}
	
	## finally set the ownerships to the new project to the git group
	
	exec { "Recursive_Chown_${name}":
	    command => "/bin/chown -R ${gitgrp}:${gitgrp} /srv/${gitgrp}/${projectname}.git",
	      subscribe => Exec["Initilize_Depot_${name}"],
	    refreshonly => true,
	}
	
}