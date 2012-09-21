##
## Install the dovecot package.
##
## Sample use:
##
##   puppet_dovecot_imap::install { ipv6 => 'no' }
##
class puppet_dovecot_imap::install ( $ipv6 ='' ) {
  
    include puppet_dovecot_imap::service
    include puppet_dovecot_imap::params

  
    if ! ( $ipv6 in [ "yes", "no" ]) {
        fail("FAIL: Missing ipv6 capability parameter ($ipv6), must be 'yes' or 'no'.")
    }
    
    if $ipv6 == 'no' {
        $mysourcetemplate = 'puppet_dovecot_imap/dovecot.conf.ipv4.erb'
    
    } elsif ($ipv6 == 'yes')  {
        $mysourcetemplate = 'puppet_dovecot_imap/dovecot.conf.ipv4_ipv6.erb'
    
    }
    
    # Quirk for ipv4 only host. Install the 'initial' config before package
    # install. Otherwise dovecot install will abort since dovecot defaults
    # to set listen to ip4+ipv6, and 'terminate itself' on an ipv4 system.
    
    file { "/etc/dovecot":
		 ensure => directory,
		  owner => 'root',
		  group => 'root',
	}

    # Debian does not overwrite the /etc/dovecot.conf during package install!
    
    file { "/etc/dovecot/dovecot.conf":
        content =>  template( $mysourcetemplate ),
          owner => 'root',
          group => 'root',
         before => Package["dovecot-imapd"],
         notify => Class["puppet_dovecot_imap::service"],
	} 
    
    # now install dovecot
  
    package { "dovecot-imapd" : ensure => present }
     
    ##
    ## Selection configuration files to manage by Puppet.
    ## 10-auth.conf includes a selection of *.ext files.
    ##

    file { "/etc/dovecot/conf.d/10-auth.conf" : 
         source => "puppet:///modules/puppet_dovecot_imap/10-auth.conf",
          owner => 'root',
          group => 'root',
    }  
    
    ##
    ## Local dovecot configurations changes can sometimes
    ## override settings in conf.d/ with local.conf.
    ## Test with 'doveconf -a' and 'doveconf -n'
    ##
    
    # facter variables
    
    $mydomain = $::domain
    
    file { "/etc/dovecot/local.conf":
        content =>  template( 'puppet_dovecot_imap/local.conf.erb' ),
		  owner => 'root',
		  group => 'root',
         notify => Class["puppet_dovecot_imap::service"],
	}    
    
    file { "/etc/dovecot/imap.passwd":
        ensure => present,
		 owner => 'root',
		 group => 'root',
	}    

    ####################################################################
    #
    # Unsecure authentication (PLAIN) with imap access from mail clients
    # Matching IMAP access is in the puppet_mutt::params configuration
    #
    ####################################################################

    $imapuser1 = $::puppet_dovecot_imap::params::myuser1
    $imapuser2 = $::puppet_dovecot_imap::params::myuser2
    
    $imapuser1pwd = $::puppet_dovecot_imap::params::myuser1pwd
    $imapuser2pwd = $::puppet_dovecot_imap::params::myuser2pwd
    

    puppet_utils::append_if_no_such_line { "create_imap_user_${imapuser1}" :
                        
                        file => '/etc/dovecot/imap.passwd',
                        line => $imapuser1pwd,
    }
    
    puppet_utils::append_if_no_such_line { "create_imap_user_${imapuser2}" :
                        
                        file => '/etc/dovecot/imap.passwd',
                        line => $imapuser2pwd,
    }
    
}