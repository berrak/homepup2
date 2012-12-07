##
## Configure global git user name/email/editor etc.
## Different host machines are used for diffrent coding
## projects (carbon: puppet, mordor: perl) with github.
##
## Note: On the git sever the user 'git1', 'git2' etc must exist and
##       have user keys in the '~/.ssh/authorized_keys' file. Keys
##       should not have a password (it's not used anyway) but
##       the git1 user (unix) password is used for authorization.
##       Keys is only used for authentication and encryption.
##
##       If not user 'git1' is pre-set up by admin manually this git
##       server install will fail, with missing '/home/git1' - errors.
##
##       Create the git1 user with:
##                       adduser git1
##                       --> enter unix password at prompt.
##
##       Usage of alternative shell like git-shell complicates the
##       creation of the repository (but may be changed later).
##      
##
## Sample use:
##
##     puppet_git::config { 'bekr' : codehost => 'mordor' }
##
define puppet_git::config ( $codehost = '' ) {

    include puppet_git::install
    include puppet_git::params
    
    # facter - check that we target correct host
    
    $myhost = $::hostname 

    case $codehost {

        'carbon': {

            $mygitname = $::puppet_git::params::gitname_puppet
            $mygitemail = $::puppet_git::params::gitemail_puppet
        
        }
        
        'mordor',
        'shire' : {

            $mygitname = $::puppet_git::params::gitname_cpan
            $mygitemail = $::puppet_git::params::gitemail_cpan
        
        }

        'valhall',
        'warp' : {

            $mygitname = $::puppet_git::params::gitname_server
            $mygitemail = $::puppet_git::params::gitemail_server
        
        }

        default: {
        
            fail("FAIL: No coding host name ($codehost) given as parameter.")
        
        }
    
    }
    
    $mygiteditor = $::puppet_git::params::giteditor_nano
    
    file { "/home/${name}/.gitconfig" :
          content =>  template( 'puppet_git/gitconfig.erb' ),
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
    
    
    
    
    
    
    
        
}