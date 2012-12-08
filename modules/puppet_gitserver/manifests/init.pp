##
## Manage the git depot on the server
##
class puppet_gitserver {

    include puppet_gitserver::install, puppet_gitserver::params, puppet_gitserver::config

}