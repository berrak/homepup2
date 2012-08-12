##
## This define zero out the history file after each login.
## 
## Sample usage:
##			admin_server::nohistory { 'gondor' :}
##
define admin_server::nohistory {

    if ! ( $name in [ "gondor" ] ) {
		fail("Unknown server host ($name). Not in list for use of zero history.")
	}

	file { "/root/.bash_history":
		ensure => link,
		target => '/dev/null',
	}

}
