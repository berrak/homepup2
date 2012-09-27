##
## This class configure and set up the tripwire policy.
##
class puppet_tripwire::config {

    include puppet_tripwire::params

	# directory for tripwire 'default' text configuration files
	# these are the file which is managed by puppet. When changing
	# policy and/or configuration please run the scripts
	# 'tripwire.updateconfiguration' and/or 'tripwire.updatepolicy'
	
	file { "/usr/local/etc/tripwire":
		ensure => "directory",
		owner => 'root',
		group => 'staff',
		mode => '0750',
	}
	
    ## tripwire policy file (twpol.txt)
	
	$mymailto = "emailto = $::puppet_tripwire::params::mailto"

	file { "/usr/local/etc/tripwire/twpol.txt" :
        content =>  template( 'puppet_tripwire/twpol.txt.erb' ),
		  owner => 'root',
		  group => 'root',
		   mode => '0600',
		require => File["/usr/local/etc/tripwire"],
	}


    ## tripwire configuration file (twcfg.txt)

    $myeditor = $::puppet_tripwire::params::editorpath
	$mysmtphost = $::puppet_tripwire::params::smtphost
	$mytmpdirectory = $::puppet_tripwire::params::twtmpdirectory

	file { "/usr/local/etc/tripwire/twcfg.txt" :
        content =>  template( 'puppet_tripwire/twcfg.txt.erb' ),
		  owner => 'root',
		  group => 'root',
		   mode => '0600',
		require => File["/usr/local/etc/tripwire"],
	}
	
	# if using a custom tmp directory, we may need to create it
	
	if $mytmpdirectory != '/tmp' {
	
		file { $mytmpdirectory :
		    ensure => "directory",
		     owner => 'root',
		     group => 'root',
		      mode => '0640',			 
	    }
	}


}
