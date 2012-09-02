##
## 'Define' to install mutt resource file.
##
##  Sample use:
##  	puppet_mutt::install { 'root': mailserver_hostname => 'rohan' }
##      puppet_mutt::install { 'bekr':  }
##
define puppet_mutt::install ( $mailserver_hostname='' ) {

    # mutt configuration for the mail server and all other hosts

    if $::hostname == $mailserver_hostname {
        $mailspooldirectory = '~/Maildir'
        
    } else {
        $mailspooldirectory = ''
    
    }

    if $name == 'root' {
    
        file { "/root/.muttrc" : 
            content =>  template( 'puppet_mutt/muttrc.erb' ),
              owner => 'root',
              group => 'root',
        }
    
    } else {

        file { "/home/${name}/.muttrc" : 
            content =>  template( 'puppet_mutt/muttrc.erb' ),
              owner => $name,
              group => $name,
        }
        
    }
    
}