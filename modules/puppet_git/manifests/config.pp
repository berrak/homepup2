##
## Configure git user name/email/etc
##
## Sample use:
##
##    class { puppet_git::config: gituser => 'bekr' }
##
define puppet_git::config ( $gituser = '' )
{

    include puppet_git
    
    if ! $gituser in [ 'bekr' ] {
        fail("FAIL: Gituser parameter ($gituser) is missing.")
    }
    
    
    
    
    
}