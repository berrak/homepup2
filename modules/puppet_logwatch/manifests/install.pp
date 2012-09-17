#
# Class to manage logwatch
#
class puppet_logwatch::install {

    package  { "logwatch": ensure => installed }  

}