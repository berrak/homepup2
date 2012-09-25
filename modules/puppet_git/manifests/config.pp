##
## Configure global git user name/email/editor etc
##
## Sample use:
##
##     class { puppet_git::config: gituser => 'bekr' }
##
define puppet_git::config ( $gituser = '' )
{

    if ! ( $gituser in [ "bekr" ] ) {
        fail("FAIL: Git user parameter ($gituser) does not exist on this system.")
    }

    include puppet_git::install
    include puppet_git::params

    $mygitname = $::puppet_git::params::gitname
    $mygitemail = $::puppet_git::params::gitemail
    $mygiteditor = $::puppet_git::params::giteditor
    
    file { '/home/${gituser}/.gitconfig' :
          content =>  template( 'puppet_git/gitconfig.erb' ),
            owner => $gituser,
            group => $gituser,
          require => Package["git"],
    }
        
}