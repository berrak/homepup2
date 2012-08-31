##
## Class to manage mutt Mail User Agent (mua).
##
class puppet_mutt {

   include puppet_mutt::install 

   package { "mutt" : ensure => present }

}