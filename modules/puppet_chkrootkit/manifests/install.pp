##
## Install chkrootkit
##
class puppet_chkrootkit::install {

    package { "chkrootkit": ensure => installed }

}