##
## Manage the client puppet-itself class
##
class puppet_agent {

    include puppet_agent::install, puppet_agent::config, puppet_agent::tools, puppet_agent::params

}