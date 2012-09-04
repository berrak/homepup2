#
# Various configuration actions required 
# due to my changes/additions in local.conf
#
class puppet_dovecot_imap::config {

    ## create unique dovecot log files

    file { "/var/log/dovecot-imap.err":
		 ensure => present,
		  owner => 'root',
		  group => 'root',
	}

    file { "/var/log/dovecot-imap.info":
		 ensure => present,
		  owner => 'root',
		  group => 'root',
	}

}