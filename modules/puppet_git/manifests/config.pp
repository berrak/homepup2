##
## Configure global git user name/email/editor etc.
## Different host machines are used for diffrent coding
## projects (carbon: puppet, mordor: perl) with github.
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
            $mygiteditor_nano = $::puppet_git::params::giteditor
        
        }
        
        'mordor',
        'shire' : {

            $mygitname = $::puppet_git::params::gitname_cpan
            $mygitemail = $::puppet_git::params::gitemail_cpan
            $mygiteditor = $::puppet_git::params::giteditor_nano
        
        }

        'valhall',
        'warp' : {

            $mygitname = $::puppet_git::params::gitname_local
            $mygitemail = $::puppet_git::params::gitemail_local
            $mygiteditor = $::puppet_git::params::giteditor_nano
        
        }

        default: {
        
            fail("FAIL: No coding host name ($codehost) given as parameter.")
        
        }
    
    } 
    
    file { "/home/${name}/.gitconfig" :
          content =>  template( 'puppet_git/gitconfig.erb' ),
            owner => $name,
            group => $name,
          require => Package["git"],
    }
        
}