##
## Manage the git depot on the server
##
class puppet_gitsrv::params {

    # git server email and name
    
    $gitname = 'gitdepot'
    $gitemail = 'root@home.tld'
    
    # favorite git editor (incl path)
    
    $giteditor_nano = '/bin/nano'

}