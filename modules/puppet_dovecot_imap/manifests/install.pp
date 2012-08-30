##
## Install the dovecot package.
##
## Sample use:
##
##   puppet_dovecot_imap::install { ipv6 => 'no' }
##
class puppet_dovecot_imap::install ( $ipv6 ='' ) {
  
    if ! ( $ipv6 in [ "yes", "no" ]) {
        fail("FAIL: Missing ipv6 capability parameter ($ipv6), must be 'yes' or 'no'.")
    }
    
    if $ipv6 == 'no' {
        $mylisten = 'listen = *'
    
    } elsif ($ipv6 == 'yes')  {
        $mylisten = 'listen = *,::'  
    
    }
    
    # Quirk for ipv4 only host. Install the 'initial' config before package
    # install. Otherwise dovecot install will abort since dovecot defaults
    # to set listen to ip4+ipv6, and 'terminate itself' on an ipv4 system.
    
    file { "/etc/dovecot":
		ensure => directory,
		owner => 'root',
		group => 'root',
	}

    # debian installer should not overwrite this initial /etc/dovecot.conf 

    file { "initial_dovecot_conf_file" :
           name => '/etc/dovecot/dovecot.conf',
        content =>  template( 'puppet_dovecot_imap/dovecot.conf.initial.erb' ),
          owner => 'root',
          group => 'root',
    } 
  
    package { "dovecot-imapd" : ensure => present }
    
}