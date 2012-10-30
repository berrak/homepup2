##
## Manage software raid
##
class puppet_raid {

    include puppet_raid::install, puppet_raid::config, puppet_raid::params

}