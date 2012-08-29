##
## This class starts the dovecot service (imap).
##
class puppet_dovecot_imap::service {

    include puppet_dovecot_imap::install

	service { "dovecot":
		
		    ensure => running,
		 hasstatus => true,
		hasrestart => true,
		    enable => true,
		   require => Class["puppet_dovecot_imap::install"],

	}

}