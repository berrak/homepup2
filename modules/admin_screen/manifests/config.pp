##
##  Configure screen
##
class admin_screen::config {
 
# systemwide screen resource file 
 
	file { "/etc/screenrc":
		source => "puppet:///modules/admin_screen/screenrc",
		 owner => 'root',
		 group => 'root',
		  mode => '0640',
	   require => Package["screen"],
    }
	
}