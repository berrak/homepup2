#
# procmail parameters
#
class puppet_procmail::config {

    include puppet_procmail::params

    define install_user_procmailrc () {
    
            if $name == $::puppet_procmail::params::rootmailuser {
        
            file {"/home/${name}/.procmailrc":      
                source => "puppet:///modules/puppet_procmail/admin.procmailrc",
                 owner => $name,
                 group => $name,
               require => Class["puppet_procmail::install"],
            }        
        
            # directory for server procmail recipes
        
        	file { "/home/${name}/.procmail":
                ensure => "directory",
                 owner => $name,
                 group => $name,
	        }
        
            file {"/home/${name}/.procmail/recipes.rc":      
                content => template("puppet_procmail/recipes.erb"),
                  owner => $name,
                  group => $name,
                require => File["/home/${name}/.procmail"],
            }
        
        } else {
        
            file {"/home/${name}/.procmailrc":      
                source => "puppet:///modules/puppet_procmail/user.procmailrc",
                 owner => $name,
                 group => $name,
               require => Class["puppet_procmail::install"],
            }
        
        }
    
    }
    
    # install global, local user resource files and Maildir on mail server only

    if $::hostname == $::puppet_procmail::params::mailserver_hostname {

        file {"/etc/procmailrc":      
             source => "puppet:///modules/puppet_procmail/procmailrc",
              owner => 'root',
              group => 'root',
            require => Class["puppet_procmail::install"],
        }
        
        # logrotation of procmail logfiles
        
        file {"/etc/logrotate.d/procmail":      
             source => "puppet:///modules/puppet_procmail/procmail",
              owner => 'root',
              group => 'root',
            require => Class["puppet_procmail::install"],
        }
        
        # helper script to create Maildir structure 'on-the-fly'
        # used sometimes in procmail pipe recepies.
        
        file {"/usr/local/bin/procmail.createmaildir":      
             source => "puppet:///modules/puppet_procmail/procmail.createmaildir",
              owner => 'root',
              group => 'staff',
               mode => '0644', 
            require => Class["puppet_procmail::install"],
        }    
        
        
        # For each mail user, install a ~/.procmailrc for their recipes
        # Roots' ~/.procmailrc goes to the defined 'admin' user.
        
        install_user_procmailrc { $::puppet_procmail::params::mailuserlist  :}
        
        
        # append folder name to dovecot-imap 'subscriptions' file for icedove.
        # note: use capilized host names in this file to match the 'recipes.rc' file.
        
        $subscriptionfolders = $::puppet_procmail::params::hostsubscriptionfolders
        
        file {"/home/${::puppet_procmail::params::rootmailuser}/Maildir/subscriptions":      
            content => template("puppet_procmail/subscriptions.erb"),
              owner => $::puppet_procmail::params::rootmailuser,
              group => $::puppet_procmail::params::rootmailuser,
        }
        
    }

}