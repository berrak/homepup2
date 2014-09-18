##
## Install minicom
##
class puppet_minicom::install {

    package { "minicom": ensure => installed }
    
}