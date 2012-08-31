#
# Create simple password file for access imap tests. (Note only
# for initial debugging, change later to stronger authentication)
#
class puppet_dovecot_imap::passwd {

    include puppet_utils::append_if_no_such_line

    file { "/etc/dovecot/imap.passwd":
        ensure => present,
		 owner => 'root',
		 group => 'root',
	}    

    puppet_utils::append_if_no_such_line { "create_imap_user" :
                        
                        file => '/etc/dovecot/imap.passwd',
                        line => 'bekr:{PLAIN}pass',
    }

}