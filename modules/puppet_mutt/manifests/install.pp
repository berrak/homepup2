##
## 'Define' to install mutt resource file.
##
##  Sample use:
##  	puppet_mutt::install { 'bekr': }
##      puppet_mutt::install { 'root': }
##
define puppet_mutt::install {

    if $name == 'root' {
    
        file { "/root/.muttrc" : 
            source => "puppet:///modules/puppet_mutt/muttrc",
             owner => 'root',
             group => 'root',
        }
    
    } else {

        file { "/home/${name}/.muttrc" : 
            source => "puppet:///modules/puppet_mutt/muttrc",
             owner => $name,
             group => $name,
        }
        
    }
    
}