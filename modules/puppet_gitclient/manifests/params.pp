##
## Parameters for global git user template
##
class puppet_gitclient::params {

    # global email and name
    
    $gitname_puppet = 'berrak'
    $gitemail_puppet = 'bkronmailbox-git@yahoo.se'
    
    $gitname_cpan = 'bkron'
    $gitemail_cpan = 'bkron@cpan.org'
    
    # $gitname_server = 'git'
    # $gitemail_server = 'git@home.tld'
    
    
    # favorite git editor (incl path)
    
    $giteditor_nano = '/bin/nano'
    
}