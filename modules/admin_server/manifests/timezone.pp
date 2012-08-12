##
## This define set the local time zone on servers.
## Only required with a minimal server install.
##
## Sample usage:
##			admin_server::timezone { 'CET' :}
##
define admin_server::timezone {

    if ! ( $name in [ "CET" ]) {
		fail("Unknown timzone parameter ($name)")
	}
	

	file { "/etc/localtime":
		ensure => link,
		target => "/usr/share/zoneinfo/${name}",
	}
	

}
