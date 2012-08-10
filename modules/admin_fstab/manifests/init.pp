##
## This class manage the system 'fstab' file. Place a host specific file
## in the source directory prefixed with output of 'hostname'+"."+"fstab"
##
class admin_fstab {

	$myhostname = $::hostname	

	file { "/etc/fstab":
		source => "puppet:///modules/admin_fstab/${myhostname}.fstab",
		owner => 'root',
		group => 'root',
		mode => '644',
	}


}
