##
## puppet_ssh manage openssh server and clients.
##
class puppet_ssh {

    include puppet_ssh::install, puppet_ssh::config, puppet_ssh::service

}