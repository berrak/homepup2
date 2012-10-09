#
# procmail parameters
#
class puppet_procmail::config {

    include puppet_procmail::params

    define install_user_procmailrc () {
    
        if $name == $::puppet_procmail::params::rootmailuser {
        
            file {"/home/${name}/.procmailrc":      
                source => "puppet:///modules/puppet_procmail/admin_procmail",
                 owner => 'root',
                 group => 'root',
               require => Class["puppet_procmail::install"],
            }
        
        } else {
        
            file {"/home/${name}/.procmailrc":      
                source => "puppet:///modules/puppet_procmail/user_procmail",
                 owner => 'root',
                 group => 'root',
               require => Class["puppet_procmail::install"],
            }
        
        }
    
    }
    
    # install the global and local user resource files on the mail server only

    if $::hostname == $::puppet_procmail::params::mailserver_hostname {

        file {"/etc/procmailrc":      
             source => "puppet:///modules/puppet_procmail/procmail",
              owner => 'root',
              group => 'root',
            require => Class["puppet_procmail::install"],
        }
        
        # For each mail user, install a ~/.procmailrc for their recipes
        # Roots' ~/.procmailrc goes to defined admin user.
        
        install_user_procmailrc { $::puppet_procmail::params::mailuserlist  :}
    
    }

}