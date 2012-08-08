##
## Manage Puppet master itself class
##
class puppet_master {

    include puppet_master::install, puppet_master::config, puppet_master::service, puppet_master::params

}