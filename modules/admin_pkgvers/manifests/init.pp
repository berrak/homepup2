##
## Class for detailed control of Debian packages with apt preferences.
##
class admin_pkgvers {

	# ensure that apt's /preferences.d directory exists
	
	file { "/etc/apt/preferences.d":
		ensure => directory,
		 owner => 'root',
		 group => 'root',
	}

    include admin_pkgvers::aptpin, admin_pkgvers::params

}