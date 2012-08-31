##
## Class to manage mutt Mail User Agent (mua).
##
class puppet_mutt::install {

    package { "mutt" : ensure => present }

}