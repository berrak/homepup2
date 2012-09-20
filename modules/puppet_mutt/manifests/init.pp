##
## Class to manage mutt Mail User Agent (mua).
##
class puppet_mutt {

    include puppet_mutt::params
    
    package { "mutt" : ensure => present }

}