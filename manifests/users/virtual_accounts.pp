##
## Class to manage virtual system users 
## (accounts), i.e. not human users.
##
class virtual_accounts {

    # used for dovecot. /var/mail exist already. 

    @user { "vmail" :
        ensure => present,
           uid => 'vmail',
           gid => 'vmail',
        groups => 'mail',
          home => '/var/mail',
         shell => '/sbin/nologin',  
    }

}