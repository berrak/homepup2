##
## Class to manage tiger (report system security vulnerabilities)
##
class puppet_tiger::config {


	file { "/etc/tiger/tigerrc":
		 source => "puppet:///modules/puppet_tiger/tigerrc",
		  owner => 'root',
		  group => 'root',
		   mode => '0600',
        require => Package["tiger"],
	}
    
	file { '/etc/tiger/cronrc':
		 source => "puppet:///modules/puppet_tiger/cronrc",
		  owner => 'root',
		  group => 'root',
		   mode => '0644',		  
        require => Package["tiger"],          
	}
	
	# warning/fail messages from tiger that we want to ignore!
	# Note: can be tricky to use egrep reg expressions.
	
	file { '/etc/tiger/tiger.ignore':
		 source => "puppet:///modules/puppet_tiger/tiger.ignore",
		  owner => 'root',
		  group => 'root',
		   mode => '0644',		  
        require => Package["tiger"],          
	}	
	
}