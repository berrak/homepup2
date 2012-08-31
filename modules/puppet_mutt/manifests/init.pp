##
## Class to manage mutt Mail User Agent (mua).
##
class puppet_mutt {

   package { "mutt" : ensure => present }

   include puppet_mutt::install 

}