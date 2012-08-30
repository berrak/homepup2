#
# Module to manage one central postfix lan server mta and many
# satellite mta's. Only inter lan mails are allowed.
#
class puppet_postfix::service {

    service { "postfix" :
		    ensure => running,
		 hasstatus => true,
		hasrestart => true,
		    enable => true,
		   require => Package["postfix"],
	}

}