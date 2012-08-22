##
## Puppet client configuration class
##
class puppet_agent::config {

    include puppet_agent::params

    $puppetserver = $::puppet_agent::params::mypuppetserver_fqdn
    $puppetserverhostname = $::puppet_agent::params::mypuppetserver_hostname

    $nodename = $::fqdn
    
    file { "/etc/puppet/puppet.conf" :
        ensure => present,
        content => template("puppet_agent/puppet.conf.erb"),
        owner => 'root',
        group => 'root',
        require => Class["puppet_agent::install"],
    }
    
    notify {"PUPPET AGENT RECONFIGURE: PLEASE RELOAD AGENT MANUALLY TO TAKE EFFECT":}

}