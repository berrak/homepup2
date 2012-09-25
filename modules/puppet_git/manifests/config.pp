##
## Configure git user name/email/etc
##
## Sample use:
##
##     puppet_git::config { 'bekr' : }
##
define puppet_git::config {

    # ensure that we run install and get our parameters
    include puppet_git
    
    if ! $name in [ 'bekr' ] {
        fail("FAIL: Gituser parameter ($name) is missing.")
    }
    
    
    
    
    
}