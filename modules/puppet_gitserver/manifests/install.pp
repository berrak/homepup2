##
## Manage the git depot on the server
##
class puppet_gitserver::install {

    include puppet_gitserver::params

    package { "git": ensure => installed }
    
    $gitdepotname = $::puppet_gitserver::params::gitname
    $gitdepotemail = $::puppet_gitserver::params::gitemail
    
    file { '/etc/gitconfig' :
		content =>  template( 'puppet_gitserver/gitconfig.erb' ),
		  owner => 'root',
		  group => 'root',
	}
    
}