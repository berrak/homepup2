##
## Define to manage mutt Mail User Agent (mua).
##
define puppet_mutt::install {

    package { "mutt" : ensure => present }
    
    file { "/home/${name}/.muttrc" : 
        source => "puppet:///modules/puppet_mutt/muttrc",
        require => Package["mutt"],
    }
    

}