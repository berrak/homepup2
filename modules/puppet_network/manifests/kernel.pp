##
## Setting up kernel networking with
## /etc/sysctl.conf
##
class puppet_network::kernel {

    # facter

    $myhost = $::hostname


    # special case for our gateway host (enable forwarding)
    
    if $myhost == 'gondor' {

        file { "/etc/sysctl.conf":
            source => "puppet:///modules/puppet_network/sysctl.conf.${myhost}",
             owner => 'root',
             group => 'root',
              mode => '0644',
        }
    
    } else {
    
        file { "/etc/sysctl.conf":
            source => "puppet:///modules/puppet_network/sysctl.conf.default",
             owner => 'root',
             group => 'root',
              mode => '0644',  
    
    }

}