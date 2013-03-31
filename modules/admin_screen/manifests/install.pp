##
## Install screen
##
class admin_screen::install {

    package { "screen": ensure => installed }
    
}