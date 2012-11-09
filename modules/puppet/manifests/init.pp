##
## Manage Puppet (both master and agent)
##
class puppet {

    include puppet::install, puppet::params, puppet::config, puppet::service

}