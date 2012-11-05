##
## Manage NFSv4 server
##
class puppet_nfs4srv {

    include puppet_nfs4srv::install, puppet_nfs4srv::config, puppet_nfs4srv::service, puppet_nfs4srv::params

}