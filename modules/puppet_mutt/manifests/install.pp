##
## 'Define' to install mutt resource file.
##
##  Sample use:
##  	puppet_mutt::install { 'root': mailserver_hostname => 'rohan' }
##      puppet_mutt::install { 'bekr': mailserver_hostname => 'rohan' }
##
define puppet_mutt::install ( $mailserver_hostname='' ) {

    if $mailserver_hostname == '' {
        fail("FAIL: The mailserver hostname parameter is missing.")
    }
    

    $mydomain = $::domain
    
    ###########################################################
    ## were simple unsecure authentication for test (change) ##
    $mypasswd = 'pass'

    # mutt configuration for direct access on the mail server
    # and else for remote access from our lan hosts with imap.

    if $::hostname == $mailserver_hostname {
        $mailspool = '~/Maildir'
        $mailfolder = '~/Maildir'
        
        $imap_user = ''
        $imap_passwd = ''
        
        
    } else {
        $mailspool = "imap://${mailserver_hostname}/INBOX"
        $mailfolder = "imap://${mailserver_hostname}.${mydomain}"
                
        $imap_user = "set imap_user = $name"
        $imap_passwd = "set imap_pass = $mypasswd"
    
    }
    

    # do not create Maildir for root (already by module 'root_home')
    
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
        
        # set up ~/Maildir mailbox structure for each user
        
        file { "/home/${name}/Maildir":
            ensure => "directory",
              owner => $name,
              group => $name,
              mode => '0750',
        }
        
        exec { "make_${name}_maildirs_new":
            command => "/bin/mkdir -p /home/${name}/Maildir/new",
            subscribe => File["/home/${name}/Maildir"],
            refreshonly => true,
        }
        
        exec { "make_${name}_maildirs_cur":
            command => "/bin/mkdir -p /home/${name}/Maildir/cur",
            subscribe => File["/home/${name}/Maildir"],
            refreshonly => true,
        }	
        
        exec { "make_${name}_maildirs_tmp":
            command => "/bin/mkdir -p /home/${name}/Maildir/tmp",
            subscribe => File["/home/${name}/Maildir"],
            refreshonly => true,
        }
        
        # ~/Maildir/.Drafts
        
        file { "/home/${name}/Maildir/.Drafts":
             ensure => "directory",
              owner => $name,
              group => $name,
               mode => '0750',
            require => File["/home/${name}/Maildir"],
        }
        
        exec { "make_${name}_maildirs_drafts_new":
            command => "/bin/mkdir -p /home/${name}/Maildir/.Drafts/new",
            subscribe => File["/home/${name}/Maildir/.Drafts"],
            refreshonly => true,
        }
    
        exec { "make_${name}_maildirs_drafts_cur":
            command => "/bin/mkdir -p /home/${name}/Maildir/.Drafts/cur",
            subscribe => File["/home/${name}/Maildir/.Drafts"],
            refreshonly => true,
        }
        
        exec { "make_${name}_maildirs_drafts_tmp":
            command => "/bin/mkdir -p /home/${name}/Maildir/.Drafts/tmp",
            subscribe => File["/home/${name}/Maildir/.Drafts"],
            refreshonly => true,
        }
    
    
        # ~/Maildir/.Sent
        
        file { "/home/${name}/Maildir/.Sent":
             ensure => "directory",
              owner => $name,
              group => $name,
               mode => '0750',
            require => File["/home/${name}/Maildir"],
        }	
        
        exec { "make_${name}_maildirs_sent_new":
            command => "/bin/mkdir -p /home/${name}/Maildir/.Sent/new",
            subscribe => File["/home/${name}/Maildir/.Sent"],
            refreshonly => true,
        }
    
        exec { "make_${name}_maildirs_sent_cur":
            command => "/bin/mkdir -p /home/${name}/Maildir/.Sent/cur",
            subscribe => File["/home/${name}/Maildir/.Sent"],
            refreshonly => true,
        }
        
        exec { "make_${name}_maildirs_sent_tmp":
            command => "/bin/mkdir -p /home/${name}/Maildir/.Sent/tmp",
            subscribe => File["/home/${name}/Maildir/.Sent"],
            refreshonly => true,
        }     
        
        
    }
    
}