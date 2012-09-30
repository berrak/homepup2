##
## Setting up kernel networking with
## /etc/sysctl.conf
##
class puppet_network::kernel {

    # facter

    $myhost = $::hostname

    file { "/etc/sysctl.conf":
        source => "puppet:///modules/puppet_network/sysctl.conf.${myhost}",
         owner => 'root',
         group => 'root',
          mode => '0644',
    }

}