##
## puppet_ssh manage openssh server and clients.
##
class puppet_ssh::install {

    include puppet_ssh::params
    
    if $::hostname == $::puppet_ssh::params::sshserverhostname {
    
        package { "openssh-server": ensure => installed }    
    
    } else {
    
        package { "openssh-client": ensure => installed }
    
    }
    
}