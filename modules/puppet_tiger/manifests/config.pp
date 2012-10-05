##
## Class to manage tiger (report system security vulnerabilities)
##
class puppet_tiger::config {


    include puppet_tiger::params

	file { "/etc/tiger/tigerrc":
		content => template( "puppet_tiger/tigerrc.erb" ),
		  owner => 'root',
		  group => 'root',
		   mode => '0600',
        require => Package["tiger"],
	}
    
	file { '/etc/tiger/cronrc':
		content => template( "puppet_tiger/cronrc.erb" ),
		  owner => 'root',
		  group => 'root',
		   mode => '0644',		  
        require => Package["tiger"],          
	}
	
	# warning/fail messages from tiger that we want to ignore!
	
	file { '/etc/tiger/tiger.ignore':
		 source => "puppet:///modules/puppet_tiger/tiger.ignore",
		  owner => 'root',
		  group => 'root',
		   mode => '0644',		  
        require => Package["tiger"],          
	}	
	
}