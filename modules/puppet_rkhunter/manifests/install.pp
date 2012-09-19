#
# Class to install package rkhunter
#
class puppet_rkhunter::install {

    package  { "rkhunter": ensure => installed }  

}