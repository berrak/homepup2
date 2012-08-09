##
## This class installs cups.
##
class puppet_cups::install {

	package { "cups":
		ensure => present, 
	}

}
