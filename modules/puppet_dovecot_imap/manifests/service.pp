##
## This class starts the dovecot service (imap).
##
class puppet_dovecot_imap::service {

	service { "dovecot":
		
		    ensure => running,
		 hasstatus => true,
		hasrestart => true,
		    enable => true,
		   require => Package["dovecot-imapd"],
	}

}