##
## Manage software raid
##
class puppet_raid::install {

    package { "mdadm" : ensure => installed }

}