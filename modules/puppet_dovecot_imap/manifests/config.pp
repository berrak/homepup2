##
## Configure dovecot.
##
## Sample use:
##
##   puppet_dovecot_imap::config { ipv6 => 'no' }
##
class puppet_dovecot_imap::config ( $ipv6 ='' ) {

        include puppet_dovecot_imap::install

        if ! ( $ipv6 in [ "yes", "no" ]) {
        
            fail("FAIL: Missing ipv6 capability parameter ($ipv6), must be 'yes' or 'no'.")
        
        }
        
        if $ipv6 == 'no' {
        
           $mylisten = 'listen = *'
           
        } elsif ($ipv6 == 'yes')  {
        
           $mylisten = 'listen = *,::'  
        
        }

        # for ipv4 only listen change, do not depend on a successful install, only
        # that /etc/dovecot exist and then change the dovecot configuration file.

        file { '/etc/dovecot/dovecot.conf' :
        
            content =>  template( 'puppet_dovecot_imap/dovecot.conf.erb' ),
              owner => 'root',
              group => 'root',

            
        }
        
}