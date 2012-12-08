##
## Manage the git depot on the server
##
## Sample use:
##
##     puppet_gitsrv::config { 'git2' : projectname => 'project2' }
##
define puppet_gitsrv::config ( $projectname = '' ) {

    include puppet_gitsrv::install
    include puppet_gitsrv::params
    
    if $projectname == '' {

        fail("FAIL: No project name ($projectname) given as parameter.")
    }

	$mygitname = $::puppet_gitsrv::params::gitname
    $mygitemail = $::puppet_gitsrv::params::gitemail
    $mygiteditor = $::puppet_gitsrv::params::giteditor_nano
    
    file { "/root/.gitconfig" :
          content =>  template( 'puppet_gitsrv/gitconfig.erb' ),
            owner => $name,
            group => $name,
          require => Package["git"],
    }
    
}