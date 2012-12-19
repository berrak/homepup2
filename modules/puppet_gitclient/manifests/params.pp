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
    
    
    # favorite git editor (incl path) and alias for nice log graph
    
    $giteditor_nano = '/bin/nano'
    $log_graph_alias = 'log --graph --pretty=format:"%Cred%h%Creset -%C(Yellow)%d%Creset%s%Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative'
    
}