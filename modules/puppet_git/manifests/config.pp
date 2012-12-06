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

            if $myhost != $codehost {
                fail("FAIL: Given host name ($codehost) does not match actual host: ($myhost).")
            }

            $mygitname = $::puppet_git::params::gitname_puppet
            $mygitemail = $::puppet_git::params::gitemail_puppet
            $mygiteditor = $::puppet_git::params::giteditor
        
        }
        
        'mordor',
        'shire' : {

            if $myhost != $codehost {
                fail("FAIL: Given host name ($codehost) does not match actual host: ($myhost).")
            }

            $mygitname = $::puppet_git::params::gitname_cpan
            $mygitemail = $::puppet_git::params::gitemail_cpan
            $mygiteditor = $::puppet_git::params::giteditor
        
        }

        $::puppet_git::params::git_serverlist: {

            $mygitname = $::puppet_git::params::gitname_local
            $mygitemail = $::puppet_git::params::gitemail_local
            $mygiteditor = $::puppet_git::params::giteditor
        
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