##
## Manage the git depot on the server
##
class puppet_gitsrv {

    include puppet_gitsrv::install, puppet_gitsrv::params, puppet_gitsrv::config

}