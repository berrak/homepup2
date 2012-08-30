##
## This class configure dovecot and its users 
## with dovecot configuration snippets.
##
class puppet_dovecot_imap::config {

    include puppet_dovecot_imap::service
    include puppet_dovecot_imap::install

    # create unique dovecot log files

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
    
	# dovecot configuration snippets

    file { "/etc/dovecot/conf.d":
		 source => "puppet:///modules/puppet_dovecot_imap/files",
		recurse => true,
		require => Package["dovecot-imapd"],
         notify => Class["puppet_dovecot_imap::service"],
	}

}