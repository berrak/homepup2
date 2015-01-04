##
## Manage NFSv4 client
##
class puppet_nfs4client {

    include puppet_nfs4client::install, puppet_nfs4client::config,
        puppet_nfs4client::service, puppet_nfs4client::params

}
