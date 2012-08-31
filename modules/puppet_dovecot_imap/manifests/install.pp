##
## Install the dovecot package.
##
## Sample use:
##
##   puppet_dovecot_imap::install { ipv6 => 'no' }
##
class puppet_dovecot_imap::install ( $ipv6 ='' ) {
  
    include puppet_dovecot_imap::service, puppet_dovecot_imap::vmail
    include virtual_groups, virtual_accounts
  
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
    
    # create vmail home directory
    
    file { "/home/vmail":
		 ensure => directory,
		  owner => 'vmail',
		  group => 'vmail',
        require => Class["puppet_dovecot_imap::vmail"],
	}
    
    ##
    ## local dovecot configurations changes in 
    ## local.conf overrides settings in conf.d/
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

    puppet_utils::append_if_no_such_line { "create_imap_user" :
                        
                        file => '/etc/dovecot/imap.passwd',
                        line => 'bekr:{PLAIN}pass',
    }
    
}