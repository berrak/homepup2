##
## Class to manage tiger (report system security vulnerabilities)
##
##  Sample use:
##     puppet_tiger::config { install_rec_tripwire => 'no' }
##     puppet_tiger::config { install_rec_tripwire => 'yes' }
##
class puppet_tiger::config ( install_rec_tripwire = '' ) {


    if ! ( $install_rec_tripwire in [ "yes", "no" ]) {
        fail("FAIL: Missing if recommended tripwire should be installed ($install_rec_tripwire), this must be 'yes' or 'no'.")
    }

    # Tiger will install tripwire as an automatic dependency, which 
	# cause various errors messages in logs (if not configured/used)
    
	include puppet_tiger::install
	
	if ( $install_rec_tripwire == 'no' ) {
	    package { "tripwire":
		    ensure => purged }
	}
	

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