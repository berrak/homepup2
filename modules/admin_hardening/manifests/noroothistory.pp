##
## This zero out the roots' history file after each login.
##
## (but this cause chkrootkit to report this as a
## suspicious link, thus it needs some configuration) 
##
class admin_hardening::noroothistory {

	file { "/root/.bash_history":
		ensure => link,
		target => '/dev/null',
	}

}
