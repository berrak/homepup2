##
## This class configure dovecot and its users 
## with dovecot configuration snippets.
##
class puppet_dovecot_imap::config {

    # create unique dovecot log files

    file { "/var/log/dovecot-imap.err":
		 ensure => file,
		  owner => 'root',
		  group => 'root',
	}

    file { "/var/log/dovecot-imap.info":
		 ensure => file,
		  owner => 'root',
		  group => 'root',
	}
    
	# dovecot configuration snippets

    file { "/etc/dovecot/conf.d/10-logging.conf":
		 source => "puppet:///modules/puppet_dovecot_imap/10-logging.conf",
		  owner => 'root',
		  group => 'root',
         notify => Class["puppet_dovecot_imap::service"],
	}
	
}
