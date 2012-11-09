##
## Manage Puppet (both master and agent)
##
class puppetize {

    include puppetize::install, puppetize::params, puppetize::config, puppetize::service

}