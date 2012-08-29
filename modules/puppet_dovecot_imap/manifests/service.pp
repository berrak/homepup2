##
## This class starts the dovecot service (imap).
##
class puppet_dovecot_imap::service {

    include puppet_dovecot_imap::config

	service { "dovecot":
		
		    ensure => running,
		 hasstatus => true,
		hasrestart => true,
		    enable => true,
		   require => File["/etc/dovecot/dovecot.conf"],

	}

}