##
## Manage the git depot on the server
##
class puppet_gitserver::params {

    # Required system wide setting!
    # Otherwise git does not accept any
    # server repositories without it.
    
    # git depot server email and name
    
    $gitname = 'Git Depot'
    $gitemail = 'root@home.tld'
    


}