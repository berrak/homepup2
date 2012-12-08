##
## Manage the git depot on the server
##
## Sample use:
##
##  puppet_gitsrv::config { 'git2_project1': gitgrp => 'git2',projectname => 'project1'}
##
define puppet_gitsrv::config ( $gitgrp ='', $projectname = '' ) {

    include puppet_gitsrv::install
    include puppet_gitsrv::params
    
    if $projectname == '' {

        fail("FAIL: No project name ($projectname) given as parameter.")
    }

    if $gitgrp == '' {

        fail("FAIL: No git group name ($gitgrp) given as parameter.")
    }

	$mygitname = $::puppet_gitsrv::params::gitname
    $mygitemail = $::puppet_gitsrv::params::gitemail
    $mygiteditor = $::puppet_gitsrv::params::giteditor_nano
    
    file { "/root/.gitconfig" :
          content =>  template( 'puppet_gitsrv/gitconfig.erb' ),
            owner => 'root',
            group => 'root',
          require => Package["git"],
    }
	
	# create the git depot for the developers in group '$gitgrp'
	file { "/srv/${gitgrp}":
		ensure => "directory",
		 owner => 'root',
		 group => $gitgrp,
		  mode => '0750',
	}
	
    
}