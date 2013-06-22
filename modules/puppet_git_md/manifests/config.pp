##
## CLI tool to convert Git flavor of markdown to HTML
##
define puppet_git_md::config {

    include puppet_git_md::install
	
	# array of real users...(not root, or system accounts)
		
    if ( $name in ["bekr"] ) {
    
        file { "/home/${name}/bin/flavor.rb":
            source => "puppet:///modules/puppet_git_md/flavor.rb",
             owner => $name,
             group => $name,
              mode => '0750',
           require => Class["puppet_git_md::install"],
        }
        
	} else {
		
	    fail("FAIL: Unknown user ($name) for puppet on this host!")
		
	}
    
}