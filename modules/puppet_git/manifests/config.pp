##
## Configure global git user name/email/editor etc
##
## Sample use:
##
##     puppet_git::config { 'gitglobal' : gituser => 'bekr' }
##
define puppet_git::config ( $gituser = '' )
{

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