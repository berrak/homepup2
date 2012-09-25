##
## Manage git
##
class puppet_git {

    include puppet_git::install, puppet_git::config, puppet_git::params

}