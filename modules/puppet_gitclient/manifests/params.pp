##
## Parameters for global git user template
##
class puppet_gitclient::params {

    # Global email and names
    
    
    # Puppet management
    
    $gitname_puppet = 'berrak'
    $gitemail_puppet = 'bkronmailbox-git@yahoo.se'
    
    
    
    # Perl development
    
    $gitname_cpan = 'bkron'
    $gitemail_cpan = 'bkron@cpan.org'
    
    
    
    # Python development
    
    $gitname_debinix = 'debinix'
    $gitemail_debinix = 'bertil.kronlund@gmail.com'    
    
    
    # Default git editor (incl path) and nice log format
    
    $giteditor_nano = '/bin/nano'
    $logformat = '%Cred%h%Creset -%C(Yellow)%d%Creset%s%Cgreen(%cr) %C(bold blue)<%an>%Creset'
    
}