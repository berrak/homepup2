##
## puppet_cluster_ssh managage group of ssh servers
##
class puppet_cluster_ssh {

    include puppet_cluster_ssh::install, puppet_cluster_ssh::config

}