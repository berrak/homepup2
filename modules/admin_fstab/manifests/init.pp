##
## This class manage the system 'fstab' file. Place a host specific file
## in the source directory prefixed with output of 'hostname'+"."+"fstab"
##
## Sample use:
##    class { admin_fstab : fstabhost => 'carbon' }
##
class admin_fstab ( $fstabhost='' ) {
	
	if ! ( $fstabhost in [ "carbon", "gondor", "rohan", "mordor" ] ) {
	
		fail("FAIL: Could not find ($fstabhost) fstab file on puppetmaster! Please copy it over.")
	
	}

	file { "/etc/fstab":
		source => "puppet:///modules/admin_fstab/${fstabhost}.fstab",
		owner => 'root',
		group => 'root',
		mode => '644',
	}


}
