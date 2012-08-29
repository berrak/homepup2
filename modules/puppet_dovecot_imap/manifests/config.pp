##
## Configure dovecot.
##
## Sample use:
##
##   puppet_dovecot_imap::config { ipv6 => 'no' }
##
class puppet_dovecot_imap::config ( $ipv6 ='' ) {

        if ! ( $ipv6 in [ "yes", "no" ]) {
        
            fail("FAIL: Missing ipv6 capability parameter ($ipv6), must be 'yes' or 'no'.")
        
        }
        
        if $ipv6 == 'no' {
        
           $mylisten = 'listen = *'
           
        } elsif ($ipv6 == 'yes')  {
        
           $mylisten = 'listen = *,::'  
        
        }

        file { '/etc/dovecot/dovecot.conf' :
        
            content =>  template( 'puppet_dovecot_imap/dovecot.conf.erb' ),
              owner => 'root',
              group => 'root',
            require => Package["dovecot"],
            
        }
        
}