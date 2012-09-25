##
## Parameters for global git user template
##
class puppet_git::params {

    # global email and name
    
    $gitname_puppet = 'berrak'
    $gitemail_puppet = 'bkronmailbox-git@yahoo.se'
    
    $gitname_cpan = 'bkron'
    $gitemail_cpan = 'bkron@cpan.org'
    
    # favorite git editor (incl path)
    
    $giteditor = '/bin/nano'
    
}