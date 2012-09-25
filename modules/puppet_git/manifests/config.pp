##
## Configure git user name/email/etc
##
## Sample use:
##
##    class { puppet_git::config: gituser => 'bekr' }
##
define puppet_git::config ( $gituser = '' )
{

    include puppet_git::install
    include puppet_git::params
    
    if ! $gituser in [ 'bekr' ] {
        fail("FAIL: Gituser parameter ($gituser) is missing.")
    }
    
    
    
    
    
}