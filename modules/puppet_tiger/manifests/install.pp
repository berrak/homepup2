##
## Class to manage tiger (report system security vulnerabilities)
##
class puppet_tiger::install {

    package { "tiger": ensure => installed }
    
}