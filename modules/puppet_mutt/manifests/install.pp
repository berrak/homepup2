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
        
        file { "/root/Maildir":
            ensure => "directory",
             owner => 'root',
             group => 'root',
        }
        
        file { "/root/Maildir/Drafts":
             ensure => "directory",
              owner => 'root',
              group => 'root',
            require => File["/root/Maildir"],
        }
        
        file { "/root/Maildir/Sent":
             ensure => "directory",
              owner => 'root',
              group => 'root',
            require => File["/root/Maildir"],
        }        
        
    
    } else {

        file { "/home/${name}/.muttrc" : 
            content =>  template( 'puppet_mutt/muttrc.erb' ),
              owner => $name,
              group => $name,
        }
        
        file { "/home/${name}/Maildir":
            ensure => "directory",
             owner => $name,
             group => $name,
        }        
        
        file { "/home/${name}/Maildir/Drafts":
             ensure => "directory",
              owner => $name,
              group => $name,
            require => File["/home/${name}/Maildir"],
        }
        
        file { "/home/${name}/Maildir/Sent":
            ensure => "directory",
              owner => $name,
              group => $name,
            require => File["/home/${name}/Maildir"],             
        }
        
        
    }
    
}