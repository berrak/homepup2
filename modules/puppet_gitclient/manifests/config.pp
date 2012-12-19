##
## Configure global client git user name/email/editor etc.
## Different host machines are used for diffrent coding
## projects (carbon: puppet, mordor: perl) with github.
##
## Note:
##     On server depot must the git user/group 'git1', 'git2' exist
##     exist and client users have their keys in that user 
##      '~/.ssh/authorized_keys' file. Keys does not require passwords.
##     The git1 user (unix) password is used for authorization.
##     Keys is only used for authentication and encryption.
##
## Sample use:
##
##     puppet_git::config { 'bekr' : codehost => 'mordor' }
##
define puppet_gitclient::config ( $codehost = '' ) {

    include puppet_gitclient::install
    include puppet_gitclient::params
    
    # facter - check that we target correct host
    
    $myhost = $::hostname 

    case $codehost {

        'carbon': {

            $mygitname = $::puppet_gitclient::params::gitname_puppet
            $mygitemail = $::puppet_gitclient::params::gitemail_puppet
        
        }
        
        'mordor',
        'shire' : {

            $mygitname = $::puppet_gitclient::params::gitname_cpan
            $mygitemail = $::puppet_gitclient::params::gitemail_cpan
        
        }

        #'valhall',
        #'warp' : {
        #
        #    $mygitname = $::puppet_gitsrv::params::gitname_server
        #    $mygitemail = $::puppet_gitsrv::params::gitemail_server
        #
        #}

        default: {
        
            fail("FAIL: No coding host name ($codehost) given as parameter.")
        
        }
    
    }
    
    $mygiteditor = $::puppet_gitclient::params::giteditor_nano
	$mylogformat = $::puppet_gitclient::params::logformat
    
    file { "/home/${name}/.gitconfig" :
          content =>  template( 'puppet_gitclient/gitconfig.erb' ),
            owner => $name,
            group => $name,
          require => Package["git"],
    }
    
    file { "/home/${name}/.ssh":
		ensure => "directory",
		 owner => $name,
		 group => $name,
		  mode => '0700',
	}
	
	# user git bashrc snippet
	
	file { "/home/${name}/bashrc.d/git.rc" :
		ensure => present,
		source => "puppet:///modules/puppet_gitclient/git.rc",
		 owner => $name,
		 group => $name,
	}
    
}