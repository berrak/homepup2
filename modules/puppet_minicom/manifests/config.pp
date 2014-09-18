##
##  Configure minicom
##
class puppet_minicom::config {
 
# configuration file for minicom
 
	file { "/etc/minicom/minirc.dfl":
		source => "puppet:///modules/puppet_minicom/minirc.dfl",
		 owner => 'root',
		 group => 'root',
		  mode => '0644',
	   require => Package["minicom"],
    }
	
}