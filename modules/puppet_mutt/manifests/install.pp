##
## Define to manage mutt Mail User Agent (mua).
##
define puppet_mutt::install {

    file { "/home/${name}/.muttrc" : 
        source => "puppet:///modules/puppet_mutt/muttrc",
         owner => $name,
         group => $name,
    }
    
}