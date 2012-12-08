##
## Manage the git depot on the server
##
class puppet_gitserver::install {

    package { "git": ensure => installed }

}