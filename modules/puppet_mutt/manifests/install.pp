##
## Define to manage mutt Mail User Agent (mua).
##
define puppet_mutt::install {

    include puppet_mutt

    file { "/home/${name}/.muttrc" : 
        source => "puppet:///modules/puppet_mutt/muttrc",
        require => Package["mutt"],
    }
    

}