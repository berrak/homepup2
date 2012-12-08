##
## Manage the git depot on the server
##
class puppet_gitsrv::install {

    package { "git": ensure => installed }

}