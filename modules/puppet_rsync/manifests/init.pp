##
## Backup user data with rsync
##
class puppet_rsync {

    include puppet_rsync::install, puppet_rsync::config, puppet_rsync::params, puppet_rsync::service

}